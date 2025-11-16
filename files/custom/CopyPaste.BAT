@echo off
chcp 65001 >nul 2>&1
mode con: cols=110 lines=50

:MENU
cls
color 0A
echo.
echo    ==================================================================================================
echo                                           GYATT UTILITIES
echo                                      LPI Information Database
echo    ==================================================================================================
echo.
echo    [1] System Information            [6] Building Blocks          [11] Search by ID
echo    [2] Quick Access                  [7] Scripts and Tools        [12] Favorites
echo    [3] Glitch Gears                  [8] NPCs and Bots            [13] Settings
echo    [4] Music IDs                     [9] Badge Givers             [14] Help
echo    [5] Gears and Weapons            [10] Vehicles                 [15] Add New ID
echo.
echo                                                                    [0]  Exit
echo    ==================================================================================================
echo.
set "choice="
set /p choice="    Enter your choice: "

if /i "%choice%"=="1" goto SYSTEM
if /i "%choice%"=="2" goto QUICK
if /i "%choice%"=="3" goto GLITCH
if /i "%choice%"=="4" goto MUSIC
if /i "%choice%"=="5" goto WEAPONS
if /i "%choice%"=="6" goto BLOCKS
if /i "%choice%"=="7" goto SCRIPTS
if /i "%choice%"=="8" goto NPC
if /i "%choice%"=="9" goto BADGES
if /i "%choice%"=="10" goto VEHICLES
if /i "%choice%"=="11" goto SEARCH
if /i "%choice%"=="12" goto FAVORITES
if /i "%choice%"=="13" goto SETTINGS
if /i "%choice%"=="14" goto HELP
if /i "%choice%"=="15" goto ADDID
if /i "%choice%"=="0" goto EXIT
color 0C
echo.
echo    ERROR: Invalid choice. Please try again...
timeout /t 2 >nul
goto MENU

:SYSTEM
cls
color 0B
echo.
echo    ==================================================================================================
echo                                        SYSTEM INFORMATION
echo    ==================================================================================================
echo.
echo    32 bit limit ......................... 2147483647
echo    32 bit max float value ............... 340282346638528859811704183484516925440
echo    max F3X coordinate ................... 340282356779733642748073463979561713663
echo    max hexadecimal F3X coordinate ....... 0XFFFFFF7FFFFFFBFFFFFFFFFFFFFFFFFF
echo    max F3X rotation ..................... 19496742886243632864614343622268622471168
echo    max hexadecimal F3X rotation ......... 0X394BB81821A7D500000000000000000000
echo.
echo    ==================================================================================================
echo.
echo    [M] Return to Menu    [0] Exit
echo.
set /p nav="    Choice: "
if /i "%nav%"=="M" goto MENU
if /i "%nav%"=="0" goto EXIT
goto SYSTEM

:QUICK
cls
color 0E
echo.
echo    ==================================================================================================
echo                                          QUICK ACCESS
echo    ==================================================================================================
echo.
echo    POPULAR ITEMS:
echo    --------------------------------------------------------------------------------------------------
echo    crash mesh ........................... 18757481864
echo    C418 song ............................ 130672051659118
echo    Spooky Scary Skeletons ID ............ 71956674693421
echo    Text Display ......................... 1367834043
echo    Remove Water/Terrain ................. 846089351
echo    Old Special Bricks ................... 900103501
echo.
if exist "custom_quick.txt" (
    echo    CUSTOM ITEMS:
    echo    --------------------------------------------------------------------------------------------------
    type custom_quick.txt
    echo.
)
echo    ==================================================================================================
echo.
echo    [M] Return to Menu    [A] Add Item    [0] Exit
echo.
set /p nav="    Choice: "
if /i "%nav%"=="M" goto MENU
if /i "%nav%"=="A" set "addcategory=quick" & goto ADDID_PROCESS
if /i "%nav%"=="0" goto EXIT
goto QUICK

:GLITCH
cls
color 0D
echo.
echo    ==================================================================================================
echo                                          GLITCH GEARS
echo    ==================================================================================================
echo.
echo    36017373 ..................... Glitch gear cloner
echo    583475573 .................... ornirnio leaderbnoard
echo    16975388 ..................... Glitch f3x
echo    561245776 .................... 2006
echo    15093053680 .................. headless
echo    80568884 ..................... begin 1
echo    81047202 ..................... begin 2
echo    120011175571061 .............. lingagu
echo    12716598710 .................. camera
echo    4842212980 ................... camlock
echo    6519512493 ................... scream
echo    18757481864 .................. crash mesh
echo    88279107242161 ............... trollge texture
echo    135173304364958 .............. skybox lvl 1
echo.
if exist "custom_glitch.txt" (
    echo    CUSTOM ITEMS:
    echo    --------------------------------------------------------------------------------------------------
    type custom_glitch.txt
    echo.
)
echo    ==================================================================================================
echo.
echo    [M] Return to Menu    [A] Add Item    [0] Exit
echo.
set /p nav="    Choice: "
if /i "%nav%"=="M" goto MENU
if /i "%nav%"=="A" set "addcategory=glitch" & goto ADDID_PROCESS
if /i "%nav%"=="0" goto EXIT
goto GLITCH

:MUSIC
cls
color 0C
echo.
echo    ==================================================================================================
echo                                       MUSIC IDs - PAGE 1/3
echo    ==================================================================================================
echo.
echo    17648297692 .................. sonic exe
echo    348401846 .................... dry metal scraping sound
echo    6900670817 ................... donkey laugh emote
echo    3042863895 ................... scary audio crying
echo    1846442728 ................... cringe music
echo    7458854474 ................... skype call loop
echo    359774781 .................... this server has been hacked
echo    129098116998483 .............. TOMA TOMA FONK
echo    1845855354 ................... Kalinka
echo    15689450026 .................. spooky skeletons
echo    1653848114 ................... Annoying ears tv sound
echo    757154772 .................... Roblox Death Sound Repeated
echo    133170570098799 .............. freakbob
echo    76819270320985 ............... miku
echo    90567839325615 ............... spanish
echo    121478279391811 .............. mexico
echo    133848688651683 .............. erika remix
echo    120102995443063 .............. Stray
echo    122036473710827 .............. a you! stay long!
echo.
if exist "custom_music.txt" (
    echo    CUSTOM ITEMS:
    echo    --------------------------------------------------------------------------------------------------
    type custom_music.txt
    echo.
)
echo    ==================================================================================================
echo.
echo    [N] Next Page    [A] Add Item    [M] Menu    [0] Exit
echo.
set /p nav="    Choice: "
if /i "%nav%"=="N" goto MUSIC2
if /i "%nav%"=="A" set "addcategory=music" & goto ADDID_PROCESS
if /i "%nav%"=="M" goto MENU
if /i "%nav%"=="0" goto EXIT
goto MUSIC

:MUSIC2
cls
color 0C
echo.
echo    ==================================================================================================
echo                                       MUSIC IDs - PAGE 2/3
echo    ==================================================================================================
echo.
echo    131076943264072 .............. funk tan tan tan tan tantan
echo    128934903242385 .............. Funk Slowed Rewerb
echo    93045675505687 ............... kiss me kiss me again
echo    120785124326826 .............. Im so Lucky Lucky FULL
echo    107424491541808 .............. funk montagem
echo    132643763204246 .............. resonance a a a a oh ah
echo    135881205397136 .............. Jumpstile boing Slowed
echo    76578817848504 ............... Jumpstile Slowed
echo    115859025716354 .............. Fight song COOL
echo    70386399207262 ............... Insomenia
echo    78119159364831 ............... funk for cars
echo    127738337879619 .............. The Eagle That Shines Over
echo    122597581916979 .............. The Minecraft Zombie Villager
echo    108878711230593 .............. Polka Miku
echo    75688289719937 ............... Loud Eternal Ruch
echo    96138447205390 ............... Type beat fast
echo    122916119116158 .............. lonely lonely
echo    118157652132357 .............. chat sound effect
echo    4659217874 ................... Cry Man meme
echo.
echo    ==================================================================================================
echo.
echo    [N] Next    [B] Back    [A] Add Item    [M] Menu    [0] Exit
echo.
set /p nav="    Choice: "
if /i "%nav%"=="N" goto MUSIC3
if /i "%nav%"=="B" goto MUSIC
if /i "%nav%"=="A" set "addcategory=music" & goto ADDID_PROCESS
if /i "%nav%"=="M" goto MENU
if /i "%nav%"=="0" goto EXIT
goto MUSIC2

:MUSIC3
cls
color 0C
echo.
echo    ==================================================================================================
echo                                       MUSIC IDs - PAGE 3/3
echo    ==================================================================================================
echo.
echo    118906631204450 .............. pretty rave girl
echo    5208471506 ................... Lyubaya popytka
echo    104315497961363 .............. Dance To The Beat
echo    124492519792234 .............. UNDER YOU SPELL
echo    137909689525185 .............. brainrot
echo    92199965344436 ............... Rock your body
echo    108561962330364 .............. Sunny day rampage
echo    130672051659118 .............. C418 song
echo    71956674693421 ............... Spooky Scary Skeletons ID
echo    1840684208 ................... chill
echo    1846458016 ................... 2017
echo    2875495643 ................... 8d audio
echo.
echo    ==================================================================================================
echo.
echo    [B] Back    [A] Add Item    [M] Menu    [0] Exit
echo.
set /p nav="    Choice: "
if /i "%nav%"=="B" goto MUSIC2
if /i "%nav%"=="A" set "addcategory=music" & goto ADDID_PROCESS
if /i "%nav%"=="M" goto MENU
if /i "%nav%"=="0" goto EXIT
goto MUSIC3

:WEAPONS
cls
color 09
echo.
echo    ==================================================================================================
echo                                   GEARS AND WEAPONS - PAGE 1/5
echo    ==================================================================================================
echo.
echo    962575893 .................... Foxbin's Endless Ice Slasher
echo    707236458 .................... Sword with lightning
echo    830824152 .................... LPI Sword (no damage)
echo    23153947 ..................... Gear Recycler 236442380
echo    60357972 ..................... Hedgehog Cannon
echo    125013830 .................... Scroll Of Sevelness
echo    553339698 .................... Skeleton knife
echo    18474459 ..................... Paint bucket
echo    966957087 .................... Metal Flying Witch Vacuum
echo    606138375 .................... Energy Sword X
echo    560422478 .................... Insert tool
echo    2813718951 ................... Lightsaber (cuts arms)
echo    583425450 .................... Weaponized vomit
echo    560367580 .................... Bubble item
echo    1343627665 ................... Broken tool
echo    830804357 .................... Head explosion axe
echo    830813741 .................... Fog sword with fire
echo    568562453 .................... Knife toy gamepass
echo    689876122 .................... LPI Paintgun
echo.
if exist "custom_weapons.txt" (
    echo    CUSTOM ITEMS:
    echo    --------------------------------------------------------------------------------------------------
    type custom_weapons.txt
    echo.
)
echo    ==================================================================================================
echo.
echo    [N] Next Page    [A] Add Item    [M] Menu    [0] Exit
echo.
set /p nav="    Choice: "
if /i "%nav%"=="N" goto WEAPONS2
if /i "%nav%"=="A" set "addcategory=weapons" & goto ADDID_PROCESS
if /i "%nav%"=="M" goto MENU
if /i "%nav%"=="0" goto EXIT
goto WEAPONS

:WEAPONS2
cls
color 09
echo.
echo    ==================================================================================================
echo                                   GEARS AND WEAPONS - PAGE 2/5
echo    ==================================================================================================
echo.
echo    1547909595 ................... LPI Wrench
echo    964429275 .................... Scroll of Sevenless
echo    590614386 .................... LPI Chainsaw
echo    3017639081 ................... Ice claws
echo    1038706151 ................... RoBar from gearcard
echo    3017608436 ................... Scythe
echo    830968798 .................... Throwable ducks
echo    5570899510 ................... Portable Justice
echo    563426933 .................... Sign that plays song
echo    590621060 .................... Weird sword
echo    3147030511 ................... Throwable Poison Cake
echo    720533346 .................... Broken knife
echo    563422665 .................... FF potion
echo    830949945 .................... FoxBomb
echo    1721241781 ................... GunKit (broken)
echo    4520708092 ................... Free Ivory Periastron
echo    689695087 .................... Shoots lasers
echo    689874448 .................... LPI Drink
echo    571336078 .................... Toy Knife Gamepass
echo.
echo    ==================================================================================================
echo.
echo    [N] Next    [B] Back    [A] Add Item    [M] Menu    [0] Exit
echo.
set /p nav="    Choice: "
if /i "%nav%"=="N" goto WEAPONS3
if /i "%nav%"=="B" goto WEAPONS
if /i "%nav%"=="A" set "addcategory=weapons" & goto ADDID_PROCESS
if /i "%nav%"=="M" goto MENU
if /i "%nav%"=="0" goto EXIT
goto WEAPONS2

:WEAPONS3
cls
color 09
echo.
echo    ==================================================================================================
echo                                   GEARS AND WEAPONS - PAGE 3/5
echo    ==================================================================================================
echo.
echo    2667756334 ................... Luger Pistol
echo    2667756334 ................... FoxBins' Magic Hand
echo    966706881 .................... FoxBin's Rail Runner MKII
echo    563418928 .................... Broken gun
echo    560367489 .................... Taser
echo    477204103 .................... Broken F3X
echo    2813736053 ................... Air conditioner (CSC sky)
echo    3653658272 ................... Nerfed Hedgehog launcher
echo    2839056557 ................... Sword and shield
echo    2272261736 ................... I Has Bucket Gear
echo    2740683110 ................... Green periastron (no shield)
echo    689873923 .................... Bone (invisibility)
echo    603307161 .................... More knives
echo    553351465 .................... Fixxed Orbital Piano
echo    560368801 .................... Undeployable bomb
echo    2813746381 ................... Harpoon
echo    564898488 .................... FoxBin's healing magic
echo    689871923 .................... LPI Cookie
echo    571337784 .................... More toy knives
echo.
echo    ==================================================================================================
echo.
echo    [N] Next    [B] Back    [A] Add Item    [M] Menu    [0] Exit
echo.
set /p nav="    Choice: "
if /i "%nav%"=="N" goto WEAPONS4
if /i "%nav%"=="B" goto WEAPONS2
if /i "%nav%"=="A" set "addcategory=weapons" & goto ADDID_PROCESS
if /i "%nav%"=="M" goto MENU
if /i "%nav%"=="0" goto EXIT
goto WEAPONS3

:WEAPONS4
cls
color 09
echo.
echo    ==================================================================================================
echo                                   GEARS AND WEAPONS - PAGE 4/5
echo    ==================================================================================================
echo.
echo    830792338 .................... Nightmare Sword
echo    2813714506 ................... Speed boost + fire
echo    975022539 .................... Ultimate Rocket Pod
echo    965028875 .................... Staff of Noob
echo    2785618375 ................... Snake spawner
echo    830806924 .................... Local projectiles (no damage)
echo    836286179 .................... Sword
echo    2813761484 ................... Christmas ornaments
echo    583347381 .................... I'm feeling sick gear
echo    4532316047 ................... Nerfed black hole sword
echo    75496631 ..................... Chicken gear
echo    82596339 ..................... Weapons (no damage)
echo    93656513 ..................... Disappearing hammer
echo    93652837 ..................... Disappearing hammer
echo    1420976503 ................... Two Seat Rainbow Carpet
echo    1305359656 ................... Hand spawner gear
echo    2268724392 ................... Inventory stealer
echo    1302058676 ................... FE Resize tool
echo    553345360 .................... Weird sword
echo.
echo    ==================================================================================================
echo.
echo    [N] Next    [B] Back    [A] Add Item    [M] Menu    [0] Exit
echo.
set /p nav="    Choice: "
if /i "%nav%"=="N" goto WEAPONS5
if /i "%nav%"=="B" goto WEAPONS3
if /i "%nav%"=="A" set "addcategory=weapons" & goto ADDID_PROCESS
if /i "%nav%"=="M" goto MENU
if /i "%nav%"=="0" goto EXIT
goto WEAPONS4

:WEAPONS5
cls
color 09
echo.
echo    ==================================================================================================
echo                                   GEARS AND WEAPONS - PAGE 5/5
echo    ==================================================================================================
echo.
echo    689870778 .................... Immobile lasers
echo    905396790 .................... Import tool (blacklisted)
echo    606144853 .................... Liquid sword
echo    1319218306 ................... Platform Bow
echo    5597966760 ................... Throwable Poisoned Chocolate
echo    606170157 .................... Noob spawner
echo    2813692280 ................... Throwable poison cake
echo    964370969 .................... FoxBin's The Piece Maker
echo    1405838300 ................... Broken delete tool
echo    2785562508 ................... Broken anime staff
echo    3017620592 ................... Arm remover
echo    830818871 .................... Arm remover
echo    5069674434 ................... Hunting machete
echo    830809571 .................... Rainbow Katana
echo    1565221455 ................... Glitched sword
echo    1405883639 ................... Magic carpet
echo    689874950 .................... LPI Money Bag
echo    2785599053 ................... Revolver
echo    553350197 .................... More knives
echo    553348895 .................... Boombox
echo.
echo    ==================================================================================================
echo.
echo    [B] Back    [A] Add Item    [M] Menu    [0] Exit
echo.
set /p nav="    Choice: "
if /i "%nav%"=="B" goto WEAPONS4
if /i "%nav%"=="A" set "addcategory=weapons" & goto ADDID_PROCESS
if /i "%nav%"=="M" goto MENU
if /i "%nav%"=="0" goto EXIT
goto WEAPONS5

:BLOCKS
cls
color 06
echo.
echo    ==================================================================================================
echo                                   BUILDING BLOCKS - PAGE 1/6
echo    ==================================================================================================
echo.
echo    3110755182 ................... Checkpoint (prevents death)
echo    831099294 .................... Old LPI hat dispenser
echo    560416757 .................... Brick wall
echo    900103501 .................... Old special bricks
echo    606154974 .................... LPI Wrench's noob
echo    1547634015 ................... LPI Wrench's spawn
echo    560414963 .................... Dummy near F3X
echo    560414641 .................... Black btools giver
echo    4805640186 ................... Touch To Play ID block
echo    722474273 .................... Red wedge
echo    906768224 .................... Checkerboard pattern
echo    1554213924 ................... Jumppower changer
echo    660926908 .................... Thin white part
echo    660931809 .................... Brown part (invisible sides)
echo    720541990 .................... Armor giver
echo    707234890 .................... Noob from Woa Badge
echo    67994803 ..................... Concrete block
echo    67994759 ..................... Log
echo    67994775 ..................... Wood
echo.
if exist "custom_blocks.txt" (
    echo    CUSTOM ITEMS:
    echo    --------------------------------------------------------------------------------------------------
    type custom_blocks.txt
    echo.
)
echo    ==================================================================================================
echo.
echo    [N] Next Page    [A] Add Item    [M] Menu    [0] Exit
echo.
set /p nav="    Choice: "
if /i "%nav%"=="N" goto BLOCKS2
if /i "%nav%"=="A" set "addcategory=blocks" & goto ADDID_PROCESS
if /i "%nav%"=="M" goto MENU
if /i "%nav%"=="0" goto EXIT
goto BLOCKS

:BLOCKS2
cls
color 06
echo.
echo    ==================================================================================================
echo                                   BUILDING BLOCKS - PAGE 2/6
echo    ==================================================================================================
echo.
echo    67994743 ..................... Gravel
echo    67994740 ..................... Granite
echo    67994731 ..................... Gold
echo    67994724 ..................... Cinder
echo    67994719 ..................... Cement
echo    67994712 ..................... Asphalt
echo    67994706 ..................... Aluminum
echo    67625712 ..................... Zombie Spawner
echo    67187816 ..................... Unopenable gift
echo    67187806 ..................... Christmas tree
echo    67187780 ..................... Snowman
echo    67187771 ..................... Menorah
echo    65962665 ..................... Brick block
echo    65962645 ..................... Granite block
echo    65943300 ..................... Special mesh
echo    65894507 ..................... Concrete with blue carpet
echo    65894286 ..................... Refrigerator
echo    65820169 ..................... Button on stand
echo    65820129 ..................... Magic ball
echo.
echo    ==================================================================================================
echo.
echo    [N] Next    [B] Back    [A] Add Item    [M] Menu    [0] Exit
echo.
set /p nav="    Choice: "
if /i "%nav%"=="N" goto BLOCKS3
if /i "%nav%"=="B" goto BLOCKS
if /i "%nav%"=="A" set "addcategory=blocks" & goto ADDID_PROCESS
if /i "%nav%"=="M" goto MENU
if /i "%nav%"=="0" goto EXIT
goto BLOCKS2

:BLOCKS3
cls
color 06
echo.
echo    ==================================================================================================
echo                                   BUILDING BLOCKS - PAGE 3/6
echo    ==================================================================================================
echo.
echo    65820095 ..................... Glitched Float Pad
echo    65820060 ..................... Float pad from LPI Wrench
echo    65820011 ..................... Energy core
echo    65819994 ..................... C4 (no explosion)
echo    67625690 ..................... Tesla
echo    56446583 ..................... Space Hatch
echo    67572398 ..................... Timer (cosmetic)
echo    67572390 ..................... Builderman portrait
echo    67572320 ..................... Blue concrete block
echo    67572258 ..................... Non-opening door
echo    67572237 ..................... Light switch
echo    67572224 ..................... Laser plate
echo    67572213 ..................... Circular door
echo    86374494 ..................... Meteor
echo    84929999 ..................... Crystal mountain
echo    82717697 ..................... Minecraft blue concrete
echo    115744762 .................... Black block
echo    115744374 .................... Brown block
echo    115742827 .................... Yellow block
echo.
echo    ==================================================================================================
echo.
echo    [N] Next    [B] Back    [A] Add Item    [M] Menu    [0] Exit
echo.
set /p nav="    Choice: "
if /i "%nav%"=="N" goto BLOCKS4
if /i "%nav%"=="B" goto BLOCKS2
if /i "%nav%"=="A" set "addcategory=blocks" & goto ADDID_PROCESS
if /i "%nav%"=="M" goto MENU
if /i "%nav%"=="0" goto EXIT
goto BLOCKS3

:BLOCKS4
cls
color 06
echo.
echo    ==================================================================================================
echo                                   BUILDING BLOCKS - PAGE 4/6
echo    ==================================================================================================
echo.
echo    113855979 .................... Bloxy cola machine
echo    121359440 .................... Massive baseplate
echo    844842315 .................... Water spawner
echo    701375439 .................... Huge brick
echo    69281349 ..................... Pressure Plate
echo    69281292 ..................... Radio
echo    69281057 ..................... Speaker
echo    69281032 ..................... Color-changing button
echo    23153972 ..................... Park Bench
echo    69276460 ..................... Drawbridge gate
echo    69939157 ..................... Catapult model
echo    90719419 ..................... Stone fist mesh
echo    81047202 ..................... Weird pillar
echo    80568507 ..................... Weird pillar alt
echo    105292979 .................... Cat carrier
echo    134082409 .................... Grave
echo    125896025 .................... Taxi
echo    123227932 .................... Percy Jackson Billboards
echo    65819947 ..................... Delay thing
echo.
echo    ==================================================================================================
echo.
echo    [N] Next    [B] Back    [A] Add Item    [M] Menu    [0] Exit
echo.
set /p nav="    Choice: "
if /i "%nav%"=="N" goto BLOCKS5
if /i "%nav%"=="B" goto BLOCKS3
if /i "%nav%"=="A" set "addcategory=blocks" & goto ADDID_PROCESS
if /i "%nav%"=="M" goto MENU
if /i "%nav%"=="0" goto EXIT
goto BLOCKS4

:BLOCKS5
cls
color 06
echo.
echo    ==================================================================================================
echo                                   BUILDING BLOCKS - PAGE 5/6
echo    ==================================================================================================
echo.
echo    161865355 .................... How to train dragon Billboards
echo    160802655 .................... Fireworks + pressure plate
echo    160802555 .................... Fireworks + pressure plate
echo    160802395 .................... Fireworks + pressure plate
echo    1554225939 ................... Walkspeed Pad
echo    560414250 .................... Music player
echo    599157629 .................... Secret island with dog
echo    560415640 .................... White platforms
echo    1550671308 ................... LPI Wrench radio
echo    727371256 .................... Unanchored thing with canes
echo    564913728 .................... Fog (unremovable)
echo    3028786688 ................... Moonlit
echo    903319803 .................... Killbricks
echo    952149606 .................... Text generator
echo    560417137 .................... Roblox house
echo    709637497 .................... Bricks with particles
echo    709640183 .................... Water effect
echo    1547789663 ................... Gear giver from wrench
echo    606149729 .................... Noob from wrench
echo.
echo    ==================================================================================================
echo.
echo    [N] Next    [B] Back    [A] Add Item    [M] Menu    [0] Exit
echo.
set /p nav="    Choice: "
if /i "%nav%"=="N" goto BLOCKS6
if /i "%nav%"=="B" goto BLOCKS4
if /i "%nav%"=="A" set "addcategory=blocks" & goto ADDID_PROCESS
if /i "%nav%"=="M" goto MENU
if /i "%nav%"=="0" goto EXIT
goto BLOCKS5

:BLOCKS6
cls
color 06
echo.
echo    ==================================================================================================
echo                                   BUILDING BLOCKS - PAGE 6/6
echo    ==================================================================================================
echo.
echo    569806399 .................... Castle of Bronze
echo    847345299 .................... Terrain blocks
echo    1554780073 ................... Teleporters
echo.
echo    ==================================================================================================
echo.
echo    [B] Back    [A] Add Item    [M] Menu    [0] Exit
echo.
set /p nav="    Choice: "
if /i "%nav%"=="B" goto BLOCKS5
if /i "%nav%"=="A" set "addcategory=blocks" & goto ADDID_PROCESS
if /i "%nav%"=="M" goto MENU
if /i "%nav%"=="0" goto EXIT
goto BLOCKS6

:SCRIPTS
cls
color 03
echo.
echo    ==================================================================================================
echo                                       SCRIPTS AND TOOLS
echo    ==================================================================================================
echo.
echo    1367834043 ................... Fancy text display
echo    560419694 .................... Sprint Script
echo    560419913 .................... Ragdoll on death
echo    923894226 .................... View bobbing
echo    2272946427 ................... R15 for new players
echo    1992619355 ................... R11
echo    649769709 .................... 1000 HP Gamepass (maybe)
echo    1025849174 ................... TimeAPI
echo    557018820 .................... Emotional message
echo    775764753 .................... Smooth camera
echo    560421884 .................... Double jump
echo    846089351 .................... Remove water/terrain
echo    561238759 .................... Minecraft Name Tags
echo    977181407 .................... Fake chat bubble
echo    923651590 .................... Shiftlock (maybe)
echo.
if exist "custom_scripts.txt" (
    echo    CUSTOM ITEMS:
    echo    --------------------------------------------------------------------------------------------------
    type custom_scripts.txt
    echo.
)
echo    ==================================================================================================
echo.
echo    [A] Add Item    [M] Return to Menu    [0] Exit
echo.
set /p nav="    Choice: "
if /i "%nav%"=="A" set "addcategory=scripts" & goto ADDID_PROCESS
if /i "%nav%"=="M" goto MENU
if /i "%nav%"=="0" goto EXIT
goto SCRIPTS

:NPC
cls
color 05
echo.
echo    ==================================================================================================
echo                                     NPCS AND BOTS - PAGE 1/3
echo    ==================================================================================================
echo.
echo    187790284 .................... Soldier NPC
echo    72648316 ..................... Massive NPC
echo    71536048 ..................... Monkey NPC
echo    71006520 ..................... Genie NPC
echo    69489068 ..................... Alien NPC
echo    68452456 ..................... Animated NPC
echo    82264079 ..................... Alien dog
echo    3924229481 ................... Robot NPCS
echo    93601062 ..................... Roblox zombie
echo    95401558 ..................... Black smoke figure
echo    94251705 ..................... White figure
echo    94316174 ..................... Undeletable dragon
echo    93746797 ..................... Doll in sky
echo    88117081 ..................... Goblin NPC
echo    87350670 ..................... Chimera NPC
echo    67629734 ..................... Zombie from spawner
echo    76117301 ..................... Parasite NPC
echo    101713896 .................... Blue dragon
echo    106808835 .................... Frog
echo.
if exist "custom_npc.txt" (
    echo    CUSTOM ITEMS:
    echo    --------------------------------------------------------------------------------------------------
    type custom_npc.txt
    echo.
)
echo    ==================================================================================================
echo.
echo    [N] Next Page    [A] Add Item    [M] Menu    [0] Exit
echo.
set /p nav="    Choice: "
if /i "%nav%"=="N" goto NPC2
if /i "%nav%"=="A" set "addcategory=npc" & goto ADDID_PROCESS
if /i "%nav%"=="M" goto MENU
if /i "%nav%"=="0" goto EXIT
goto NPC

:NPC2
cls
color 05
echo.
echo    ==================================================================================================
echo                                     NPCS AND BOTS - PAGE 2/3
echo    ==================================================================================================
echo.
echo    713405635 .................... More zombies
echo    121605203 .................... Zombie dog
echo    124120704 .................... Dummy
echo    124120649 .................... Dummy
echo    159856065 .................... Flying dragon
echo    158186284 .................... Broken wing dragon
echo    964882209 .................... Noob from Staff
echo    516159357 .................... Grey NPC R15
echo    623140790 .................... Noob Fighter Bot
echo    623120557 .................... Bot Fighting Bot
echo    623157745 .................... Foxbin Fighter bot
echo    623160582 .................... Bluedogz Fighter Bot
echo    623120029 .................... Bluedogz Fighter Bot
echo    713622333 .................... 3 zombies
echo    1406577583 ................... LPI Anthro NPC
echo    713421604 .................... Zombie
echo    2282122675 ................... Character with forcefield
echo    623168775 .................... Masterhalo012 Fighter Bot
echo    623123830 .................... Masterhalo012 Fighter Bot
echo.
echo    ==================================================================================================
echo.
echo    [N] Next    [B] Back    [A] Add Item    [M] Menu    [0] Exit
echo.
set /p nav="    Choice: "
if /i "%nav%"=="N" goto NPC3
if /i "%nav%"=="B" goto NPC
if /i "%nav%"=="A" set "addcategory=npc" & goto ADDID_PROCESS
if /i "%nav%"=="M" goto MENU
if /i "%nav%"=="0" goto EXIT
goto NPC2

:NPC3
cls
color 05
echo.
echo    ==================================================================================================
echo                                     NPCS AND BOTS - PAGE 3/3
echo    ==================================================================================================
echo.
echo    623116750 .................... orinrino619 Fighter Bot
echo    701379301 .................... Zombie Template
echo.
echo    ==================================================================================================
echo.
echo    [B] Back    [A] Add Item    [M] Menu    [0] Exit
echo.
set /p nav="    Choice: "
if /i "%nav%"=="B" goto NPC2
if /i "%nav%"=="A" set "addcategory=npc" & goto ADDID_PROCESS
if /i "%nav%"=="M" goto MENU
if /i "%nav%"=="0" goto EXIT
goto NPC3

:BADGES
cls
color 0E
echo.
echo    ==================================================================================================
echo                                     BADGE GIVERS - PAGE 1/2
echo    ==================================================================================================
echo.
echo    518117856 .................... badge
echo    576582129 .................... badge
echo    576583303 .................... badge
echo    475811560 .................... blacklisted badge
echo    538899036 .................... badge
echo    509577032 .................... badge
echo    507487979 .................... badge
echo    484479325 .................... badge
echo    563365537 .................... badge
echo    521091099 .................... badge
echo    538900217 .................... badge
echo    576582558 .................... badge
echo    576582869 .................... badge
echo    509577177 .................... badge
echo    507488008 .................... badge
echo    509730244 .................... badge
echo    507487878 .................... badge
echo    538900100 .................... badge
echo    67315342 ..................... badge
echo.
if exist "custom_badges.txt" (
    echo    CUSTOM ITEMS:
    echo    --------------------------------------------------------------------------------------------------
    type custom_badges.txt
    echo.
)
echo    ==================================================================================================
echo.
echo    [N] Next Page    [A] Add Item    [M] Menu    [0] Exit
echo.
set /p nav="    Choice: "
if /i "%nav%"=="N" goto BADGES2
if /i "%nav%"=="A" set "addcategory=badges" & goto ADDID_PROCESS
if /i "%nav%"=="M" goto MENU
if /i "%nav%"=="0" goto EXIT
goto BADGES

:BADGES2
cls
color 0E
echo.
echo    ==================================================================================================
echo                                     BADGE GIVERS - PAGE 2/2
echo    ==================================================================================================
echo.
echo    508603771 .................... badge
echo    576583422 .................... badge
echo    500543761 .................... badge
echo    509576797 .................... badge
echo    518265447 .................... badge
echo    896724302 .................... badge
echo.
echo    ==================================================================================================
echo.
echo    [B] Back    [A] Add Item    [M] Menu    [0] Exit
echo.
set /p nav="    Choice: "
if /i "%nav%"=="B" goto BADGES
if /i "%nav%"=="A" set "addcategory=badges" & goto ADDID_PROCESS
if /i "%nav%"=="M" goto MENU
if /i "%nav%"=="0" goto EXIT
goto BADGES2

:VEHICLES
cls
color 02
echo.
echo    ==================================================================================================
echo                                          VEHICLES
echo    ==================================================================================================
echo.
echo    6433316269 ................... Vans
echo    6433330180 ................... Super Cars
echo    6418225759 ................... Pick up Trucks
echo    6418234850 ................... SUVs
echo    6418221666 ................... Jeeps
echo    6433272094 ................... Dune Buggies
echo    6433323089 ................... Sport Cars
echo    6418239833 ................... Sedans
echo.
if exist "custom_vehicles.txt" (
    echo    CUSTOM ITEMS:
    echo    --------------------------------------------------------------------------------------------------
    type custom_vehicles.txt
    echo.
)
echo    ==================================================================================================
echo.
echo    [A] Add Item    [M] Return to Menu    [0] Exit
echo.
set /p nav="    Choice: "
if /i "%nav%"=="A" set "addcategory=vehicles" & goto ADDID_PROCESS
if /i "%nav%"=="M" goto MENU
if /i "%nav%"=="0" goto EXIT
goto VEHICLES

:ADDID
cls
color 0F
echo.
echo    ==================================================================================================
echo                                       ADD NEW ID TO DATABASE
echo    ==================================================================================================
echo.
echo    SELECT CATEGORY:
echo    --------------------------------------------------------------------------------------------------
echo    [1] Quick Access                      [6] Building Blocks
echo    [2] Glitch Gears                      [7] Scripts and Tools
echo    [3] Music IDs                         [8] NPCs and Bots
echo    [4] Gears and Weapons                 [9] Badge Givers
echo    [5] Vehicles
echo.
echo    ==================================================================================================
echo.
set /p addcategory="    Enter category number (or M for menu): "
if /i "%addcategory%"=="M" goto MENU
if "%addcategory%"=="1" set "addcategory=quick"
if "%addcategory%"=="2" set "addcategory=glitch"
if "%addcategory%"=="3" set "addcategory=music"
if "%addcategory%"=="4" set "addcategory=weapons"
if "%addcategory%"=="5" set "addcategory=vehicles"
if "%addcategory%"=="6" set "addcategory=blocks"
if "%addcategory%"=="7" set "addcategory=scripts"
if "%addcategory%"=="8" set "addcategory=npc"
if "%addcategory%"=="9" set "addcategory=badges"

:ADDID_PROCESS
cls
color 0A
echo.
echo    ==================================================================================================
echo                                     ADD NEW ID - CATEGORY: %addcategory%
echo    ==================================================================================================
echo.
echo    Enter the details for the new item:
echo    --------------------------------------------------------------------------------------------------
echo.
set /p newid="    Enter ID number: "
if "%newid%"=="" (
    echo.
    echo    ERROR: ID cannot be empty!
    timeout /t 2 >nul
    goto ADDID
)
echo.
set /p newname="    Enter item name/description: "
if "%newname%"=="" (
    echo.
    echo    ERROR: Name cannot be empty!
    timeout /t 2 >nul
    goto ADDID_PROCESS
)
echo.
echo    --------------------------------------------------------------------------------------------------
echo    ID: %newid%
echo    Name: %newname%
echo    Category: %addcategory%
echo    --------------------------------------------------------------------------------------------------
echo.
set /p confirm="    Is this correct? (Y/N): "
if /i not "%confirm%"=="Y" goto ADDID_PROCESS

setlocal enabledelayedexpansion
set "dots=...................."
set "idlen=0"
set "tempid=%newid%"
:countloop
if not "!tempid!"=="" (
    set /a idlen+=1
    set "tempid=!tempid:~1!"
    goto countloop
)
set /a dotcount=25-!idlen!
if !dotcount! lss 5 set dotcount=5
set "finaldots="
for /l %%i in (1,1,!dotcount!) do set "finaldots=!finaldots!."

echo     %newid% !finaldots! %newname% >> custom_%addcategory%.txt
endlocal

color 0A
echo.
echo    ==================================================================================================
echo                                       SUCCESS!
echo    ==================================================================================================
echo.
echo    Item successfully added to %addcategory% category!
echo.
echo    ID: %newid%
echo    Name: %newname%
echo.
echo    ==================================================================================================
echo.
echo    [A] Add another item    [V] View category    [M] Return to menu
echo.
set /p next="    Choice: "
if /i "%next%"=="A" goto ADDID
if /i "%next%"=="V" goto VIEW_CAT
if /i "%next%"=="M" goto MENU
goto MENU

:VIEW_CAT
if "%addcategory%"=="quick" goto QUICK
if "%addcategory%"=="glitch" goto GLITCH
if "%addcategory%"=="music" goto MUSIC
if "%addcategory%"=="weapons" goto WEAPONS
if "%addcategory%"=="vehicles" goto VEHICLES
if "%addcategory%"=="blocks" goto BLOCKS
if "%addcategory%"=="scripts" goto SCRIPTS
if "%addcategory%"=="npc" goto NPC
if "%addcategory%"=="badges" goto BADGES
goto MENU

:SEARCH
cls
color 0F
echo.
echo    ==================================================================================================
echo                                       SEARCH BY ID
echo    ==================================================================================================
echo.
echo    Enter an ID number to search for it in the database.
echo.
set /p searchid="    Enter ID to search (or M for menu): "
if /i "%searchid%"=="" goto SEARCH
if /i "%searchid%"=="M" goto MENU

echo.
echo    Searching for ID: %searchid%
echo    --------------------------------------------------------------------------------------------------
echo.

set "found=0"

findstr /i /c:"%searchid%" "%~f0" >nul 2>&1
if !errorlevel! equ 0 (
    echo    Found in main database:
    findstr /i /c:"%searchid%" "%~f0" | findstr /v "findstr" | findstr /v ":SEARCH"
    set "found=1"
)

for %%f in (custom_*.txt) do (
    if exist "%%f" (
        findstr /i /c:"%searchid%" "%%f" >nul 2>&1
        if !errorlevel! equ 0 (
            echo.
            echo    Found in %%f:
            findstr /i /c:"%searchid%" "%%f"
            set "found=1"
        )
    )
)

if "!found!"=="0" (
    echo    No results found for ID: %searchid%
)

echo.
echo    ==================================================================================================
echo.
pause
goto SEARCH

:FAVORITES
cls
color 0A
echo.
echo    ==================================================================================================
echo                                         FAVORITES
echo    ==================================================================================================
echo.
echo    Your favorite items will be saved here for quick access.
echo.
echo    SAVED FAVORITES:
echo    --------------------------------------------------------------------------------------------------
if exist "favorites.txt" (
    type favorites.txt
) else (
    echo    No favorites saved yet.
    echo.
    echo    To add favorites manually, create a file named "favorites.txt"
    echo    and add your favorite IDs in the format:
    echo    ID ................... Description
)
echo.
echo    ==================================================================================================
echo.
echo    [M] Return to Menu    [C] Clear Favorites    [0] Exit
echo.
set /p nav="    Choice: "
if /i "%nav%"=="M" goto MENU
if /i "%nav%"=="C" goto CLEAR_FAV
if /i "%nav%"=="0" goto EXIT
goto FAVORITES

:CLEAR_FAV
if exist "favorites.txt" (
    del "favorites.txt"
    echo.
    echo    Favorites cleared!
    timeout /t 2 >nul
)
goto FAVORITES

:SETTINGS
cls
color 07
echo.
echo    ==================================================================================================
echo                                          SETTINGS
echo    ==================================================================================================
echo.
echo    COLOR THEMES:
echo    --------------------------------------------------------------------------------------------------
echo    [1] Classic Green (Default)
echo    [2] Blue Theme
echo    [3] Red Theme
echo    [4] Purple Theme
echo    [5] Yellow Theme
echo    [6] Cyan Theme
echo.
echo    DATA MANAGEMENT:
echo    --------------------------------------------------------------------------------------------------
echo    [7] Clear All Custom Data
echo    [8] Backup Custom Data
echo    [9] View Storage Info
echo.
echo    ==================================================================================================
echo.
echo    [M] Return to Menu    [0] Exit
echo.
set /p setting="    Choice: "
if /i "%setting%"=="M" goto MENU
if /i "%setting%"=="0" goto EXIT
if "%setting%"=="1" color 0A
if "%setting%"=="2" color 09
if "%setting%"=="3" color 0C
if "%setting%"=="4" color 05
if "%setting%"=="5" color 0E
if "%setting%"=="6" color 0B
if "%setting%"=="7" goto CLEAR_DATA
if "%setting%"=="8" goto BACKUP_DATA
if "%setting%"=="9" goto STORAGE_INFO

if "%setting%" geq "1" if "%setting%" leq "6" (
    echo.
    echo    Color theme applied!
    timeout /t 2 >nul
)
goto SETTINGS

:CLEAR_DATA
cls
color 0C
echo.
echo    ==================================================================================================
echo                                      CLEAR CUSTOM DATA
echo    ==================================================================================================
echo.
echo    WARNING: This will delete ALL custom items you have added!
echo.
echo    This includes:
echo    - Custom Quick Access items
echo    - Custom Glitch Gears
echo    - Custom Music IDs
echo    - Custom Weapons
echo    - Custom Blocks
echo    - Custom Scripts
echo    - Custom NPCs
echo    - Custom Badges
echo    - Custom Vehicles
echo    - Favorites
echo.
echo    ==================================================================================================
echo.
set /p confirm="    Are you sure? Type YES to confirm: "
if /i "%confirm%"=="YES" (
    del custom_*.txt >nul 2>&1
    del favorites.txt >nul 2>&1
    echo.
    echo    All custom data has been cleared!
    timeout /t 3 >nul
) else (
    echo.
    echo    Operation cancelled.
    timeout /t 2 >nul
)
goto SETTINGS

:BACKUP_DATA
cls
color 0A
echo.
echo    ==================================================================================================
echo                                      BACKUP CUSTOM DATA
echo    ==================================================================================================
echo.
echo    Creating backup of custom data files...
echo.

if not exist "backups" mkdir backups

set "timestamp=%date:~-4%%date:~-7,2%%date:~-10,2%_%time:~0,2%%time:~3,2%%time:~6,2%"
set "timestamp=%timestamp: =0%"

for %%f in (custom_*.txt favorites.txt) do (
    if exist "%%f" (
        copy "%%f" "backups\%%f.%timestamp%.bak" >nul 2>&1
        echo    Backed up: %%f
    )
)

echo.
echo    Backup completed! Files saved in "backups" folder.
echo.
echo    ==================================================================================================
echo.
pause
goto SETTINGS

:STORAGE_INFO
cls
color 0B
echo.
echo    ==================================================================================================
echo                                      STORAGE INFORMATION
echo    ==================================================================================================
echo.
echo    CUSTOM DATA FILES:
echo    --------------------------------------------------------------------------------------------------
echo.
for %%f in (custom_*.txt favorites.txt) do (
    if exist "%%f" (
        for %%a in ("%%f") do (
            echo    %%f - %%~za bytes
        )
    ) else (
        echo    %%f - Not created yet
    )
)
echo.
echo    ==================================================================================================
echo.
pause
goto SETTINGS

:HELP
cls
color 0F
echo.
echo    ==================================================================================================
echo                                       HELP ^& INFORMATION
echo    ==================================================================================================
echo.
echo    NAVIGATION:
echo    --------------------------------------------------------------------------------------------------
echo    - Use number keys to select menu options
echo    - Press [N] for Next page, [B] for Back, [M] for Menu
echo    - Press [A] to Add new items to any category
echo    - Press [0] to exit the program
echo.
echo    ADDING NEW IDs:
echo    --------------------------------------------------------------------------------------------------
echo    - Press [A] in any category to add a new ID
echo    - Or select option [15] from the main menu
echo    - Enter the ID number and item description
echo    - Your custom items will be saved permanently
echo    - Custom items appear at the bottom of each category
echo.
echo    FEATURES:
echo    --------------------------------------------------------------------------------------------------
echo    - Browse through 10 different categories of IDs
echo    - Add custom IDs to any category
echo    - Search for specific IDs (feature 11)
echo    - Save favorites for quick access (feature 12)
echo    - Customize color themes (feature 13)
echo    - Backup and restore your custom data
echo.
echo    COLOR CODING:
echo    --------------------------------------------------------------------------------------------------
echo    - Green: Main Menu, Vehicles
echo    - Blue: System Information
echo    - Yellow: Quick Access, Badges
echo    - Purple: Glitch Gears
echo    - Red: Music IDs
echo    - Light Blue: Weapons
echo    - Brown: Building Blocks
echo    - Cyan: Scripts
echo    - Magenta: NPCs
echo.
echo    CUSTOM DATA STORAGE:
echo    --------------------------------------------------------------------------------------------------
echo    - All custom items are saved in text files
echo    - Files: custom_quick.txt, custom_music.txt, etc.
echo    - Data persists between program runs
echo    - Edit text files manually if needed
echo    - Use Settings menu to backup or clear data
echo.
echo    SEARCH FUNCTION:
echo    --------------------------------------------------------------------------------------------------
echo    - Enter any ID number to find it in the database
echo    - Searches both built-in and custom items
echo    - Results show the ID with its description
echo.
echo    ==================================================================================================
echo.
echo    [M] Return to Menu    [0] Exit
echo.
set /p nav="    Choice: "
if /i "%nav%"=="M" goto MENU
if /i "%nav%"=="0" goto EXIT
goto HELP

:EXIT
cls
color 0F
echo.
echo    ==================================================================================================
echo.
echo.
echo                               Thank you for using GYATT UTILITIES!
echo.
echo                                    Developed for LPI Community
echo.
echo                                      Closing in 3 seconds...
echo.
echo.
echo    ==================================================================================================
echo.
timeout /t 3 >nul
exit
