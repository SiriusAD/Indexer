import bb.cascades 1.3
import bb.device 1.3

Container {
    
    id: indexerContainer
    
    property variant toolX  : indexerList.toolX      // x coordinate.
    property variant toolY  : indexerList.toolY      // y coordinate.
    property variant toolAlphabet    // The tooltip alphabet(label).
    
    layout: DockLayout {
    }
    
    attachedObjects: [
        GroupDataModel {
            // The datamodel used by the indexer ListView.
            id: groupDataModel
            sortingKeys: [ "value" ]
        },
        DisplayInfo {
            id: displayInfo
        }
    ]
    
    onCreationCompleted: {
        
        // Populate the indexer list. This sample adds letters to the indexer.
        
        var alphabet = "#ABCDEFGHIJKLMNOPQRSTUVWXYZ".split("");
        for (var a = 0; a < 27; a = a + 1) {
            var map = {
                "value": alphabet[a]
            }
            groupDataModel.insert(map)
        }
    
    
    }
    
    
    Container {
        
        id: hintContainer        // The label visible when you are touching an item in the indexer.
        background: Color.create("#EFEFEF")
        
        translationX: displayInfo.pixelSize.width - 300
        translationY: toolY - 70
        
        visible: false
        
        TextArea {
            
            id: hintLabel
            text: toolAlphabet
            
            horizontalAlignment: HorizontalAlignment.Left
            verticalAlignment: VerticalAlignment.Center
            
            textStyle.fontSize: FontSize.XLarge
            textStyle.textAlign: TextAlign.Left
            
            editable: false
            backgroundVisible: false
            
            textStyle.color: Color.DarkGray
        }
    
    }
    
    ListView {
        
        id: indexerList
        
        dataModel: groupDataModel        // Datamodel for the indexer.
        scrollRole: ScrollRole.None        // The indexer's parent ListView can have ScrollRole set to ScrollRole.Main. You don't want to scroll this list.
        
        touchPropagationMode: TouchPropagationMode.PassThrough 
        horizontalAlignment: HorizontalAlignment.Right
        preferredWidth: 85
        
        // Global scoped properties are aliased by the ListView for access from a ListItem.
        property variant toolX : toolX    
        property variant toolY : toolY
        
        
        function alphabetVisible(alpha, vis) {
            // Set the current label and it's visibility.
            toolAlphabet = alpha
            hintContainer.visible = vis
        }
        
        listItemComponents: [
            
            ListItemComponent {
                type: "header"
                content: Container {
                    // You MUST have an empty header. GroupDataModel sorts values and groups them. You dont want these headers to go at the top of every item in the indexer.
                    // If you inherit from bb::cascades::DataModel and expose that to QML with your own sorting function in place, you can remove this.
                }
            },
            
            ListItemComponent {
                type: "item"
                Container {
                    
                    id: itemContainer
                    preferredWidth: 85
                    
                    // Get touch coordinates and set label.
                    onTouch: {
                        if (event.isDown() || event.isMove()) {
                            itemContainer.ListItem.view.alphabetVisible(ListItemData.value, true);
                            itemContainer.ListItem.view.toolX = event.windowX
                            itemContainer.ListItem.view.toolY = event.windowY
                        }
                        else if (event.isUp()) {
                            // Set visibility to false.
                            itemContainer.ListItem.view.alphabetVisible(ListItemData.value, false);
                            itemContainer.ListItem.view.toolX = event.windowX
                            itemContainer.ListItem.view.toolY = event.windowY
                        }
                    }
                    
                    
                    topMargin: 0
                    bottomMargin: 0
                    
                    layout: DockLayout {
                    }
                    
                    Label {
                        horizontalAlignment: HorizontalAlignment.Center
                        verticalAlignment: VerticalAlignment.Center
                        
                        text:  ListItemData.value
                        
                        textStyle.color: Color.DarkGray
                        textStyle.textAlign: TextAlign.Center
                    }
                
                }
            }
        ]
    }

}
