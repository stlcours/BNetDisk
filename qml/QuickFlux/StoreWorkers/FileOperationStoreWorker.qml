import QtQuick 2.0
import QuickFlux 1.0

import com.sunrain.bnetdisk.qmlplugin 1.0

import "../Stores"
import "../Actions"

StoreWorker {

    BDiskFileOperationDelegate {
        id: fileOperationDelegate
        onRequestFailure: {
            if (t == BDiskFileOperationDelegate.OPERATION_RENAME) {
                AppActions.snackbarInfo(qsTr("Rename file error!"));
            }
        }
        onRequestSuccess: {
            if (t == BDiskFileOperationDelegate.OPERATION_RENAME) {
                delayRefreshDir.restart();
            }
        }
    }

    // use a timer to delay refresh dirs to waiting for remote http server change internal data
    Timer {
        id: delayRefreshDir
        interval: 500
        repeat: false
        onTriggered: {
            AppActions.refreshCurrentDir();
        }
    }

    Filter {
        type: ActionTypes.fileRename
        onDispatched: {
            var path = message.path
            var name = message.newName
            fileOperationDelegate.rename(path, name);
        }
    }

}
