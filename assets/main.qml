import bb.cascades 1.3

Page {

    id: rootPage

    actionBarAutoHideBehavior: ActionBarAutoHideBehavior.HideOnScroll
    actionBarVisibility: ChromeVisibility.Compact

    property variant dataModelSize: groupDataModel.size()

    attachedObjects: [
        GroupDataModel {
            id: groupDataModel
            objectName: "groupDataModel"
            sortingKeys: [ "name" ]
            grouping: ItemGrouping.ByFirstChar
            
            // Look out for other signals (onItemsChanged)!
            onItemAdded: {
                dataModelSize = groupDataModel.size();
            }
            onItemRemoved: {
                dataModelSize = groupDataModel.size();
            }
        }
    ]

    Container {

        layout: DockLayout {
        }

        Container {
            id: boardingContainer
            // This is a placeholder. Visible when the ListView is empty.

            horizontalAlignment: HorizontalAlignment.Center
            verticalAlignment: VerticalAlignment.Center

            visible: dataModelSize == 0

            layout: DockLayout {
            }

            Label {
                horizontalAlignment: HorizontalAlignment.Center
                verticalAlignment: VerticalAlignment.Center

                text: "The list is empty."
                multiline: true

                textStyle.textAlign: TextAlign.Center
                textStyle.fontSize: FontSize.Large
                textStyle.fontFamily: "Andale Mono"
            }

        }

        ListView {

            id: listView
            dataModel: groupDataModel

            scrollRole: ScrollRole.Main
            snapMode: SnapMode.LeadingEdge

            horizontalAlignment: HorizontalAlignment.Fill
            verticalAlignment: VerticalAlignment.Fill

            layout: StackListLayout {
                headerMode: ListHeaderMode.Sticky
            }

            listItemComponents: [
                ListItemComponent {
                    type: "item"
                    StandardListItem {
                        title: ListItemData.name
                        description: ListItemData.location
                    }
                }
            ]

            onCreationCompleted: {
                
                // Insert some items to test.
                
                var itemA = {
                    name: "Ashley",
                    location: "Toronto"
                }
                var itemB = {
                    name: "Blake",
                    location: "Tampere"
                }
                var itemC = {
                    name: "Cindy",
                    location: "Copenhagen"
                }
                var itemD = {
                    name: "Drake",
                    location: "Baltimore"
                }

                for (var i = 0; i < 10; i ++) {
                    groupDataModel.insert(itemA);
                    groupDataModel.insert(itemB);
                    groupDataModel.insert(itemC);
                    groupDataModel.insert(itemD);
                }
            }
        }

        Indexer {

            horizontalAlignment: HorizontalAlignment.Right
            verticalAlignment: VerticalAlignment.Center

            onToolAlphabetChanged: {
                var z = 0

                for (var indexPath = groupDataModel.first(); z != groupDataModel.size(); indexPath = groupDataModel.after(indexPath), ++z) {
                    var item = groupDataModel.data(indexPath);
                    var target = item["name"].charAt(0);
                    if (target == toolAlphabet) {
                        listView.scrollToItem(indexPath, ScrollAnimation.Smooth);
                        //Beware of large lists. If you are scrolling through a large list, use ScrollAnimation.None.
                        break;
                    }
                }
            }
        }

    }

}
