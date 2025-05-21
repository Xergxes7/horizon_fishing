## _Horizon Fishing_
A basic open source fishing script made for QB-core

## _Dependencies_
1. [Jim Bridge](https://github.com/jimathy/jim_bridge)
2. [OX Lib](https://overextended.dev/ox_lib)
3. [PS-Inventory](https://github.com/Project-Sloth/ps-inventory)
4. [QB-Core](https://github.com/qbcore-framework/qb-core)
5. [boii-minigames](https://github.com/boiidevelopment/boii_minigames)
6. [PS-Dispatch](https://github.com/Project-Sloth/ps-dispatch)

## Setup
1. Ensure all dependcies are present
2. Adjust values in the `config.lua` file to your likings.
3. If you want logging refer to Config.Webhook in Config.lua
4. Set zones for cutting/processing and selling in cl_polyzones.lua
5. Copy images to ps-inventory/html/images
6. Copy item metadata to qb-core/shared/items.lua

## Features
* Fish from any body of water
* Process Fish
* Sell fish
* Illegal and legal fishing

## Items - QB-Core items.lua
```lua
['fishingrod'] 				        = {['name'] = 'fishingrod', 			  	  	['label'] = 'Fishing Rod', 			    ['weight'] = 10000, 		['type'] = 'item', 		['image'] = 'fishingrod.png', 			    ['unique'] = true, 		    ['useable'] = true,     ['shouldClose'] = true,	   ['combinable'] = nil,   ['description'] = 'Go catch one thats THEEEES BEEEG!'},
['oceancod'] 				        = {['name'] = 'oceancod', 			  	  	    ['label'] = 'Cod Fish', 			    ['weight'] = 1000, 		['type'] = 'item', 		['image'] = 'oceancod.png', 			    ['unique'] = false, 		['useable'] = false,    ['shouldClose'] = true,	   ['combinable'] = nil,   ['description'] = 'Cod is the common name for the demersal fish genus Gadus, belonging to the family Gadidae'},
['oceanflounder'] 				    = {['name'] = 'oceanflounder', 			  	  	['label'] = 'Flounder Fish', 			['weight'] = 2000, 		['type'] = 'item', 		['image'] = 'oceanflounder.png', 			['unique'] = false, 		['useable'] = false,    ['shouldClose'] = true,	   ['combinable'] = nil,   ['description'] = 'Flounders are a group of flatfish species.'},
['oceanmackerel'] 				    = {['name'] = 'oceanmackerel', 			  	  	['label'] = 'Mackerel Fish', 			['weight'] = 4000, 		['type'] = 'item', 		['image'] = 'oceanmackerel.png', 			['unique'] = false, 		['useable'] = false,    ['shouldClose'] = true,	   ['combinable'] = nil,   ['description'] = 'Some species of mackerel migrate in schools for long distances along the coast and other species cross oceans'},
['oceanbluefish'] 				    = {['name'] = 'oceanbluefish', 			  	  	['label'] = 'Blue Fish', 			    ['weight'] = 8000, 		['type'] = 'item', 		['image'] = 'oceanbluefish.png', 			['unique'] = false, 		['useable'] = false,    ['shouldClose'] = true,	   ['combinable'] = nil,   ['description'] = 'The bluefish is the only extant species of the family Pomatomidae.'},
['oceanboot'] 				        = {['name'] = 'oceanboot', 			  	  	    ['label'] = 'Stinky Boot', 			    ['weight'] = 3000, 		['type'] = 'item', 		['image'] = 'oceanboot.png', 			    ['unique'] = false, 		['useable'] = false,    ['shouldClose'] = true,	   ['combinable'] = nil,   ['description'] = 'Ew, hope this didnt come off a dead person.'},
['oceanchest'] 				        = {['name'] = 'oceanchest', 			  	  	['label'] = 'Seaworn Chest', 			['weight'] = 4000, 		['type'] = 'item', 		['image'] = 'oceanchest.png', 			    ['unique'] = false, 		['useable'] = true,     ['shouldClose'] = true,	   ['combinable'] = nil,   ['description'] = 'An old chest, might be loot inside!'},
['oceanlockbox'] 				    = {['name'] = 'oceanlockbox', 			  	  	['label'] = 'Seaworn Lockbox', 			['weight'] = 5000, 		['type'] = 'item', 		['image'] = 'oceanlockbox.png', 			['unique'] = false, 		['useable'] = true,     ['shouldClose'] = true,	   ['combinable'] = nil,   ['description'] = 'A rusty lockbox, it jingles when I shake it.'},
['cutfish'] 				        = {['name'] = 'cutfish', 			  	  	    ['label'] = 'Cut Fish', 			    ['weight'] = 1000, 		['type'] = 'item', 		['image'] = 'cutfish.png', 			        ['unique'] = false, 		['useable'] = false,    ['shouldClose'] = true,	   ['combinable'] = nil,   ['description'] = 'Freshly cut fish ready to be rolled into sushi or thrown on the BBQ.'},
['sushi'] 				            = {['name'] = 'sushi', 			  	  	        ['label'] = 'Sushi Rolls', 			    ['weight'] = 1000, 		['type'] = 'item', 		['image'] = 'sushi.png', 			        ['unique'] = false, 		['useable'] = false,    ['shouldClose'] = true,	   ['combinable'] = nil,   ['description'] = 'Perfectly prepared sushi rolls'},
['canoworms'] 				        = {['name'] = 'canoworms', 			  	  	    ['label'] = 'Worm Bait', 			        ['weight'] = 100, 		['type'] = 'item', 		['image'] = 'canworms.png', 			    ['unique'] = false, 		['useable'] = true,    ['shouldClose'] = true,	   ['combinable'] = nil,   ['description'] = 'Used as bait in fishing'},
['illegalfishbait'] 				= {['name'] = 'illegalfishbait', 			  	['label'] = 'Prawn Bait', 			['weight'] = 1000, 		['type'] = 'item', 		['image'] = 'illegalfishbait.png', 			['unique'] = false, 		['useable'] = true,    ['shouldClose'] = true,	   ['combinable'] = nil,   ['description'] = 'High Quality bait, not many places you can fish with this.'},
['stingray'] 				= {['name'] = 'stingray', 			  	['label'] = 'Stingray', 			['weight'] = 10000, 		['type'] = 'item', 		['image'] = 'stingray.png', 			['unique'] = false, 		['useable'] = false,    ['shouldClose'] = true,	   ['combinable'] = nil,   ['description'] = 'Something that shouldnt be taken out of the sea, best get rid of it quickly.'},
['sharkfish'] 				= {['name'] = 'sharkfish', 			  	['label'] = 'Shark', 			['weight'] = 10000, 		['type'] = 'item', 		['image'] = 'sharkfish.png', 			['unique'] = false, 		['useable'] = false,    ['shouldClose'] = true,	   ['combinable'] = nil,   ['description'] = 'Something that shouldnt be taken out of the sea, best get rid of it quickly.'},
['seaturtle'] 				= {['name'] = 'seaturtle', 			  	['label'] = 'Sea Turtle', 			['weight'] = 10000, 		['type'] = 'item', 		['image'] = 'seaturtle.png', 			['unique'] = false, 		['useable'] = false,    ['shouldClose'] = true,	   ['combinable'] = nil,   ['description'] = 'Something that shouldnt be taken out of the sea, best get rid of it quickly.'},
['dolphin'] 				= {['name'] = 'dolphin', 			  	['label'] = 'Dolphin', 			['weight'] = 10000, 		['type'] = 'item', 		['image'] = 'dolphin.png', 			['unique'] = false, 		['useable'] = false,    ['shouldClose'] = true,	   ['combinable'] = nil,   ['description'] = 'Something that shouldnt be taken out of the sea, best get rid of it quickly.'},
['cooked_fish'] 				        = {['name'] = 'cooked_fish', 			  	  	    ['label'] = 'Cooked Fish', 			    ['weight'] = 800, 		['type'] = 'item', 		['image'] = 'cooked_fish.png', 			        ['unique'] = false, 		['useable'] = true,    ['shouldClose'] = true,	   ['combinable'] = nil,   ['description'] = 'Freshly cooked fish ready to be chowed.'},

```

## Support and Customisation
No support is provided for this resource, feel free to fork and customise to your liking.