//
//  JournalUi.swift
//  superfluid
//
//  Created by Aaron Anthony on 2022-09-29.
//

import SwiftUI

struct LogUi: View {
    var body: some View {
        NavigationView {
            VStack {
                Text("Sep 29")
                Text("Rolls")
                Text("subs / taps / vid rev / points / sweeps / escapes / takedowns / passes")
            }
            .navigationTitle("Log")
        }
    }
}

struct JournalUi_Previews: PreviewProvider {
    static var previews: some View {
        LogUi()
    }
}
