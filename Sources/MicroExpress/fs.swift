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
    
    public static func readFile(_ path: String, eventLoop: EventLoop? = nil, maxSize: Int = 1024 * 1024, _ cb: @escaping ( Error?, ByteBuffer? ) -> ())
    {
//        If the caller specified an event loop explicitly (when calling readFile), use it.
//        Otherwise, check whether we are invoked from within an event loop, most likely a NIO stream handler. If yes, use that event loop.
//        If neither, use our global, shared loopGroup to create a new one. If we run into this, we likely got called outside of an event loop, e.g. to load some config file before starting the server.
    
        let eventLoop = eventLoop ?? MultiThreadedEventLoopGroup.currentEventLoop ?? loopGroup.next()
        
        //ensures that we report errors and results back on the selected event loop.
//        We do this, because FileHandle(path: path) is also a blocking operation. Ever had Finder show the Spinning Beachball? That is likely because it is blocking on such a call.
//        This we need to avoid, hence we dispatch the call to the threadpool too.
//
//        This needs an update for newer NIO versions, which include non-blocking open operations.
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
            
            //use the NIO helper and perform a read.
            fileIO.read(fileHandle: fh, byteCount: maxSize, allocator: ByteBufferAllocator(), eventLoop: eventLoop)
                .map { try? fh.close(); emit(result: $0) }
                .whenFailure { try? fh.close(); emit(error:  $0) }
        }
    }
}
