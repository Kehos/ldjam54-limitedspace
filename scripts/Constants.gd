extends Node

var AVAILABLE_ITEMS: Array[String] = [
	"GOLDEN_KEY",
	"GUN",
	"CROWBAR",
	"LOCKPICK",
	"EXPLOSIVE",
	"SHEARS",
	"DOORKNOB",
	"ID_CARD",
	"USB",
	"ROBOT_HAND",
	"FILE_TOOL",
	"FUEL",
	"FUSE",
	"BATTERY",
	"MONEY"
]

var ITEM_NAMES: Array[String] = [
	"Golden key",
	"Gun",
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
	"A simple pistol with only one bullet inside", # GUN
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
	"A golden ticket for the famous Chocolate Factory", # GOLDEN_KEY
	"There is a target on the wall from a shooting range", # GUN
	"Some broken wooden planks, it appears they have been removed with something", # CROWBAR
	"You can see an empty box of a robbery movie", # LOCKPICK
	"An alert sign preventing from explosions", # EXPLOSIVE
	"An old rusted roll of barbed wire", # SHEARS
	"An advertising brochure for a locksmith", # DOORKNOB
	"An empty identification lanyard", # ID_CARD
	"The poster of a hackers TV series", # USB
	"Some pieces that are from a broken toy robot", # ROBOT_HAND
	"The poster from a western film with a cake and some jail bars on it", # FILE_TOOL
	"A car advertisement magazine", # FUEL
	"A diagram of an electrical circuit", # FUSE
	"A sign that reads 'No more disposable batteries'", # BATTERY
	"The stock-market page from a newspaper" # MONEY
]

var DOOR_TEXT: Array[String] = [
	"There is a solid golden lock", # GOLDEN_KEY
	"The door is painted like it has a target on it with a small hole in the middle", # GUN
	"The door is covered with some solid nailed wooden planks", # CROWBAR
	"A normal door with a tiny lock. There seems that no key fits in it", # LOCKPICK
	"Someone prepared some adhesive for an explosive device", # EXPLOSIVE
	"There is a simple unlocked door, but it is covered by a lot of barbed wire", # SHEARS
	"That\'s a pretty solid metal door, but it has no doorknob", # DOORKNOB
	"You can see an electronic lock with a small slot", # ID_CARD
	"There is a complex protected computer with some pluggable ports", # USB
	"There is an apparently touch screen with the shape of a hand", # ROBOT_HAND
	"An archaic prison door with some solid steel bars", # FILE_TOOL
	"You can see the lid of a tank", # FUEL
	"There is a small door with an electrical circuit inside. Something is missing", # FUSE
	"There is a computer connected to the door with a spare cable", # BATTERY
	"Surprisingly, this is an ATM" # MONEY
]

var DOOR_ACTION: Array[String] = [
	"Wasn't that login? Of course the door opens", # GOLDEN_KEY
	"After a precise shot, the gun jams and door opens", # GUN
	"After removing the last nail, the crowbar breaks and now it is useless", # CROWBAR
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
