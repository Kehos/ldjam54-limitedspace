extends Node

var AVAILABLE_ITEMS: Array[String] = [
	"goldenkey",
	"revolver",
	"crowbar",
	"lockpick",
	"explosive",
	"shears",
	"doorknob",
	"idcard",
	"usb",
	"robothand",
	"filetool",
	"fuel",
	"fuse",
	"battery",
	"money"
]

var ITEM_NAMES: Array[String] = [
	"Golden key",
	"Revolver",
	"Crowbar",
	"Lockpick",
	"Explosive",
	"Shears",
	"Doorknob",
	"ID card",
	"USB",
	"Robot hand",
	"File tool",
	"Fuel tank",
	"Fuse",
	"Battery",
	"Money"
]

var ITEM_DESCRIPTION: Array[String] = [
	"A golden key. How lucky", # GOLDEN_KEY
	"An old revolver with only one bullet inside", # REVOLVER
	"A crowbar that is near to break", # CROWBAR
	"A set of one-use lockpicks", # LOCKPICK
	"Some plastic explosive. Can't detonate by itself", # EXPLOSIVE
	"A pair of rusted shears. They won't last long", # SHEARS
	"A fancy brand new doorknob", # DOORKNOB
	"An ID card. It reads 'Multipass'", # ID_CARD
	"A small USB key", # USB
	"A pretty advanced robot hand with some dangling wires", # ROBOT_HAND
	"A file tool. That's a classic", # FILE_TOOL
	"A big tank full of fuel", # FUEL
	"A fuse from some electronic panel", # FUSE
	"A small but fully charged portable battery", # BATTERY
	"A 10$ bill" # MONEY
]

var ITEM_CLUE: Array[String] = [
	"a poster from some gold-trading business", # GOLDEN_KEY
	"the target from a shooting range", # REVOLVER
	"a photo of some broken wooden planks. It appears they have been removed with something", # CROWBAR
	"a photo of  an empty case from a robbery movie", # LOCKPICK
	"an alert sign preventing from explosions", # EXPLOSIVE
	"a photo of an old rusted roll of barbed wire", # SHEARS
	"a page from a furniture catalog, displaying some different doors", # DOORKNOB
	"a long form to obtain an ID card", # ID_CARD
	"the poster of a hackers TV series", # USB
	"a picture of some pieces that apparently are from a broken toy robot", # ROBOT_HAND
	"the poster from a western film with a suspicious cake and some jail bars on it", # FILE_TOOL
	"the cover of a car advertisement magazine", # FUEL
	"a diagram of an electrical circuit", # FUSE
	"a sign that reads 'No more disposable batteries'", # BATTERY
	"the stock-market page from a newspaper" # MONEY
]

var DOOR_TEXT: Array[String] = [
	"There is a solid golden lock", # GOLDEN_KEY
	"The door is painted like it has a target on it with a small hole in the middle", # REVOLVER
	"The door is covered with some solid nailed wooden planks", # CROWBAR
	"A normal door with a tiny lock. There seems that no key fits in it", # LOCKPICK
	"Someone prepared some adhesive for an explosive device", # EXPLOSIVE
	"There is a simple unlocked door, but it is covered by a lot of barbed wire", # SHEARS
	"That's a pretty solid metal door, but it has no doorknob", # DOORKNOB
	"You can see an electronic lock with a small slot", # ID_CARD
	"There is a complex protected computer with some pluggable ports", # USB
	"There is an apparently touch screen with the shape of a hand", # ROBOT_HAND
	"An archaic prison door with some solid steel bars", # FILE_TOOL
	"You can see the lid of a tank", # FUEL
	"There is a small door on the side, with an electrical circuit inside. Something is missing", # FUSE
	"There is a computer connected to the door with a spare cable", # BATTERY
	"Surprisingly, this is an ATM" # MONEY
]

var DOOR_ACTION: Array[String] = [
	"Wasn't that logic? Of course the door opens", # GOLDEN_KEY
	"You walk two steps backwars. After a precise shot, the revolver jams and the door opens", # REVOLVER
	"After removing the last nail, the crowbar breaks and now it is useless. You're free to continue", # CROWBAR
	"You spend some time with the lockpicks, but in the end the door opens", # LOCKPICK
	"You stick the explosive to the adhesive and stay away. There is a surprisingly small explosion and the door opens", # EXPLOSIVE
	"Carefully you remove the barbed wire, but the shears are now useless. You can continue", # SHEARS
	"You insert the doorknob with no effort. The door can be opened now", # DOORKNOB
	"You slide the ID into the slot and after some beeps, the door opens", # ID_CARD
	"You plug the USB into the correct port and a message is displayed in a small screen: Door open", # USB
	"You place the robot hand on the shape and it magnetizes. The door is now open", # ROBOT_HAND
	"You file the bars to open yourself a path through the door", # FILE_TOOL
	"After the tank is full and you close the lid, it locks and the door opens", # FUEL
	"You place the fuse and after an electronic click, the door opens", # FUSE
	"You plug the wire to the battery and it starts charging the computer. When the battery is empty, the door opens", # BATTERY
	"You skeptically insert the bill into the ATM. Surprisingly, the door opens" # MONEY
]

# Area element names
var DOOR_AREA_NAME: String = "DoorArea"
var ITEM_AREA_NAME: String = "ItemArea"
var CLUE_AREA_NAME: String = "ClueArea"
