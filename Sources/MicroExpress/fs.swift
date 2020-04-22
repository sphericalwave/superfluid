//
//  fs.swift
//  MicroExpress
//
//  Created by Aaron Anthony on 2020-04-22.
//  Copyright © 2020 ZeeZide GmbH. All rights reserved.
//

// File: fs.swift - create this in Sources/MicroExpress
//The code works but has some flaws (e.g. a large fixed size buffer) which you would fix in a full implementation. For demonstration and low-scale purposes only!
import NIO

public enum fs  //FIXME:
{
  
  static let threadPool : BlockingIOThreadPool = {
    let tp = BlockingIOThreadPool(numberOfThreads: 4)
    tp.start()
    return tp
  }()

  static let fileIO = NonBlockingFileIO(threadPool: threadPool)

  public static
  func readFile(_ path    : String,
                eventLoop : EventLoop? = nil,
                maxSize   : Int = 1024 * 1024,
                 _ cb: @escaping ( Error?, ByteBuffer? ) -> ())
  {
    let eventLoop = eventLoop
                 ?? MultiThreadedEventLoopGroup.currentEventLoop
                 ?? loopGroup.next()
    
    func emit(error: Error? = nil, result: ByteBuffer? = nil) {
      if eventLoop.inEventLoop { cb(error, result) }
      else { eventLoop.execute { cb(error, result) } }
    }
    
    threadPool.submit { // FIXME: update for NIO 1.7
      assert($0 == .active, "unexpected cancellation")
      
      let fh : NIO.FileHandle
      do { // Blocking:
        fh = try NIO.FileHandle(path: path)
      }
      catch { return emit(error: error) }
      
      fileIO.read(fileHandle : fh, byteCount: maxSize,
                  allocator  : ByteBufferAllocator(),
                  eventLoop  : eventLoop)
        .map         { try? fh.close(); emit(result: $0) }
        .whenFailure { try? fh.close(); emit(error:  $0) }
    }
  }
}
