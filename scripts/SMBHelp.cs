/*
 * Copyright 2020 faddenSoft
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

using System;
using System.Collections.Generic;

using PluginCommon;

namespace SuperMarioBros {
    /// <summary>
    /// Helper plugin for Super Mario Bros.
    ///
    /// The game does a JSR to JumpEngine, which converts the value in the accumulator
    /// to an index into the 16-bit addresses that immediately follow the JSR, and jumps
    /// to that address.  There's no indication of count or list end, so we can't format
    /// the addresses automatically.  We can mark the JSR as "no continue" though, so that
    /// the analyzer doesn't try to treat the addresses as code.
    /// </summary>
    public class SMBHelp : MarshalByRefObject, IPlugin, IPlugin_SymbolList,
            IPlugin_InlineJsr {
        private IApplication mAppRef;
        private byte[] mFileData;

        // Only one call.
        private const string CALL_LABEL = "JumpEngine";
        private int mJumpEngineAddr;    // jsr

        public string Identifier {
            get {
                return "Super Mario Bros. Helper";
            }
        }

        public void Prepare(IApplication appRef, byte[] fileData, AddressTranslate addrTrans) {
            mAppRef = appRef;
            mFileData = fileData;

            mAppRef.DebugLog("SMBHelp(id=" +
                AppDomain.CurrentDomain.Id + "): prepare()");
        }

        public void Unprepare() {
            mAppRef = null;
            mFileData = null;
        }

        // IPlugin_SymbolList
        public void UpdateSymbolList(List<PlSymbol> plSyms) {
            // reset this every time, in case they remove the symbol
            mJumpEngineAddr = -1;

            foreach (PlSymbol sym in plSyms) {
                if (sym.Label == CALL_LABEL) {
                    mJumpEngineAddr = sym.Value;
                    break;
                }
            }
            mAppRef.DebugLog(CALL_LABEL + " @ $" + mJumpEngineAddr.ToString("x4"));
        }
        // IPlugin_SymbolList
        public bool IsLabelSignificant(string beforeLabel, string afterLabel) {
            return beforeLabel == CALL_LABEL || afterLabel == CALL_LABEL;
        }

        public void CheckJsr(int offset, int operand, out bool noContinue) {
            noContinue = (operand == mJumpEngineAddr);
        }
    }
}
