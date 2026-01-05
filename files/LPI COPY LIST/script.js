function createMatrixRain() {
    const matrixRain = document.getElementById('matrixRain');
    const chars = '01ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz$+-*/=%"\'#&_(),.;:?!\\|{}<>[]^~';
    
    for (let i = 0; i < 80; i++) {
        const char = document.createElement('div');
        char.className = 'matrix-char';
        char.textContent = chars[Math.floor(Math.random() * chars.length)];
        char.style.left = `${Math.random() * 100}vw`;
        char.style.animationDuration = `${Math.random() * 5 + 3}s`;
        char.style.animationDelay = `${Math.random() * 5}s`;
        matrixRain.appendChild(char);
        
        setInterval(() => {
            char.style.left = `${Math.random() * 100}vw`;
            char.textContent = chars[Math.floor(Math.random() * chars.length)];
        }, 8000);
    }
}

let customCodes = JSON.parse(localStorage.getItem('lpiCustomCodes')) || [];

const codes = {
    cords: [
        { id: '2147483647', desc: '32 bit limit' },
        { id: '34028234663852885981170418348451692544032', desc: 'bit max float value' },
        { id: '340282356779733642748073463979561713663', desc: 'max F3X coordinate' },
        { id: '0XFFFFFF7FFFFFFBFFFFFFFFFFFFFFFFFF', desc: 'max hexadecimal F3X coordinate' },
        { id: '19496742886243632864614343622268622471168', desc: 'max F3X rotation' },
        { id: '0X394BB81821A7D500000000000000000000', desc: 'max hexadecimal F3X rotation' }
    ],
    misc: [
        { id: '36017373', desc: 'Glitch gear cloner' },
        { id: '583475573', desc: 'ornirnio leaderboard' },
        { id: '16975388', desc: 'Glitch f3x' },
        { id: '561245776', desc: '2006 plugin (blacklisted)' },
        { id: '134082579', desc: 'headless' },
        { id: '80568884', desc: 'begin 1' },
        { id: '81047202', desc: 'begin 2' },
        { id: '120011175571061', desc: 'lingagu song' },
        { id: '12716598710', desc: 'camera' },
        { id: '842212980', desc: 'camlock gear' },
        { id: '6519512493', desc: 'scream' },
        { id: '18757481864', desc: 'crash mesh' },
        { id: '88279107242161', desc: 'trollge texture' },
        { id: '903317454', desc: 'Possibly nothing (needs testing)' },
        { id: '404489748', desc: 'Server Destroyer (blacklisted)' },
        { id: '2785569537', desc: 'Boring gear (bad and stinky)' },
        { id: '850587374', desc: 'Might need more testing' },
        { id: '941957224', desc: 'Adds small "Guest" text on 0,0' },
        { id: '2603326964', desc: 'Weird black thing spawns at 0,0' },
        { id: '857718927', desc: 'Needs testing' },
        { id: '919076290', desc: 'Needs more testing' },
        { id: '573203659', desc: "Gear doesn't work, leaves GUI" },
        { id: '160000787', desc: 'Spawns something that despawns' },
        { id: '149633637', desc: 'Spawns Leprechaun above void' },
        { id: '147928844', desc: 'Spawns toy cars above void' },
        { id: '140984100', desc: 'Spawns surfing board (does nothing)' },
        { id: '135540735', desc: "Spawns gear above void (can't grab)" },
        { id: '124125886', desc: 'Hoverboard (carpet escape only)' },
        { id: '123969891', desc: 'Unanchored block' },
        { id: '119006192', desc: 'Skate that disappears after use' }
    ],
    music: [
        { id: '114361889017703', desc: 'Fart Army Song' },
        { id: '17648297692', desc: 'sonic exe' },
        { id: '348401846', desc: 'dry metal scraping sound (EAR PIERCING)' },
        { id: '6900670817', desc: 'donkey laugh emote' },
        { id: '3042863895', desc: 'scary audio crying LOL' },
        { id: '1846442728', desc: 'cringe music' },
        { id: '7458854474', desc: 'skype call super loud loop' },
        { id: '359774781', desc: 'this server has been hacked' },
        { id: '129098116998483', desc: 'TOMA TOMA FONK' },
        { id: '1718545510', desc: 'speed up train nword' },
        { id: '6865649264', desc: 'anotha moan' },
        { id: '1845855354', desc: 'Kalinka' },
        { id: '15689450026', desc: 'spooky skeletons' },
        { id: '6784599829', desc: 'Fat Ass Farting' },
        { id: '1653848114', desc: 'Annoying ears tv sound (MUSIC PLAYER ONLY)' },
        { id: '757154772', desc: 'Roblox Death Sound Repeated 274877906944 times' },
        { id: '72988571098126', desc: 'Nword cool speed song' },
        { id: '131076943264072', desc: 'funk tan tan tan tan tantan' },
        { id: '128934903242385', desc: 'Funk Slowed Rewerb' },
        { id: '93045675505687', desc: 'kiss me kiss me again' },
        { id: '120785124326826', desc: 'Im so Lucky Lucky FULL' },
        { id: '107424491541808', desc: 'funk montagem' },
        { id: '132643763204246', desc: 'resonance a a a a oh ah' },
        { id: '135881205397136', desc: 'Jumpstile boing Slowed' },
        { id: '76578817848504', desc: 'Jumpstile Slowed' },
        { id: '115859025716354', desc: 'Fight song COOL' },
        { id: '70386399207262', desc: 'Insomenia' },
        { id: '78119159364831', desc: 'funk for cars' },
        { id: '127738337879619', desc: 'The Eagle That Shines Over' },
        { id: '81477881808390', desc: 'Можешь Распять меня раз пять' },
        { id: '122597581916979', desc: 'The Minecraft Zombie Villager' },
        { id: '108878711230593', desc: 'Polka Miku' },
        { id: '75688289719937', desc: 'Loud Eternal Ruch' },
        { id: '96138447205390', desc: 'Type beat fast' },
        { id: '118906631204450', desc: 'pretty rave girl' },
        { id: '5208471506', desc: 'Любая попытка на охраняемую территорию' },
        { id: '83124984192631', desc: 'пока мне 16' },
        { id: '104315497961363', desc: 'Dance To The Beat' },
        { id: '124492519792234', desc: 'UNDER YOU SPELL' },
        { id: '137909689525185', desc: 'brainrot' },
        { id: '92199965344436', desc: 'Rock your body' },
        { id: '108561962330364', desc: 'Sunny day rampage' },
        { id: '76641578629137', desc: 'racist audio' },
        { id: '133170570098799', desc: 'freakbob' },
        { id: '76819270320985', desc: 'miku' },
        { id: '90567839325615', desc: 'spanish' },
        { id: '121478279391811', desc: 'mexico' },
        { id: '133848688651683', desc: 'erika remix' },
        { id: '120102995443063', desc: 'Stray' },
        { id: '122036473710827', desc: 'a you! stay long!' },
        { id: '122916119116158', desc: 'lonely lonely' },
        { id: '130672051659118', desc: 'C418 song' },
        { id: '71956674693421', desc: 'Spooky Scary Skeletons ID' },
        { id: '118157652132357', desc: 'chat sound effect' },
        { id: '4659217874', desc: 'Cry Man meme - By SmukRun (Super Loud)' },
        { id: '1840684208', desc: 'chill' },
        { id: '1846458016', desc: '2017' },
        { id: '2875495643', desc: '8d audio' }
    ],
    gears: [
        { id: '962575893', desc: "Foxbin's Endless Ice Slasher (Banned)" },
        { id: '125013830', desc: 'Scroll Of Sevenless' },
        { id: '707236458', desc: 'Lightning sword that shoots' },
        { id: '830824152', desc: 'LPI Sword (no damage)' },
        { id: '23153947', desc: 'Fontain (blacklisted)' },
        { id: '236442380', desc: 'Gear Recycler' },
        { id: '60357972', desc: 'Hedgehog Cannon' },
        { id: '553339698', desc: 'Skeleton knife transformation' },
        { id: '18474459', desc: 'Paint bucket - change any color' },
        { id: '966957087', desc: 'Metal Flying Witch Vacuum (Banned)' },
        { id: '606138375', desc: 'Energy Sword X (editable particles)' },
        { id: '560422478', desc: 'Insert tool (broken, antecessor of ID Gearwall)' },
        { id: '2813718951', desc: 'Weird lightsaber cuts enemy arms' },
        { id: '583425450', desc: 'Weaponized vomit (not good)' },
        { id: '560367580', desc: 'Useless bubble item' },
        { id: '1343627665', desc: 'Broken tool (surface material only)' },
        { id: '830804357', desc: 'Axe makes enemy head explode' },
        { id: '830813741', desc: 'Sword with heavy fog + ugly fire' },
        { id: '568562453', desc: 'Knife toy gamepass' },
        { id: '689876122', desc: 'LPI Paintgun (moderate damage)' },
        { id: '1547909595', desc: 'LPI Wrench' },
        { id: '964429275', desc: 'Scroll of Sevenless (Banned)' },
        { id: '590614386', desc: 'LPI Chainsaw' },
        { id: '3017639081', desc: 'Ice claws (on gearwall)' },
        { id: '1038706151', desc: 'RoBar from gearcard gamepass' },
        { id: '3017608436', desc: 'Scythe (unknown effect)' },
        { id: '830968798', desc: 'Throwable ducks' },
        { id: '5570899510', desc: 'Portable Justice (on gearwall)' },
        { id: '563426933', desc: 'Sign that plays song when used' },
        { id: '590621060', desc: 'Weird sword' },
        { id: '4901337104', desc: 'F3X (useful if ID Gearwall blocked)' },
        { id: '3147030511', desc: 'Throwable Poison Cake' },
        { id: '720533346', desc: 'Broken knife' },
        { id: '563422665', desc: 'FF potion' },
        { id: '830949945', desc: 'FoxBomb - explodes into fox heads' },
        { id: '1721241781', desc: 'GunKit (broken)' },
        { id: '4520708092', desc: 'Free Ivory Periastron' },
        { id: '689695087', desc: 'Shoots lasers' },
        { id: '689874448', desc: 'LPI Drink (particles + speed boost)' },
        { id: '571336078', desc: 'Another Toy Knife Gamepass ID' },
        { id: '2667756334', desc: 'Luger Pistol / Magic Hand' },
        { id: '966706881', desc: "FoxBin's Rail Runner MKII (Banned)" },
        { id: '563418928', desc: 'Broken gun' },
        { id: '560367489', desc: 'Taser (untested on players)' },
        { id: '477204103', desc: 'Broken F3X' },
        { id: '2813736053', desc: 'Air conditioner - spells CSC in sky' },
        { id: '3653658272', desc: 'Nerfed Hedgehog launcher' },
        { id: '2839056557', desc: 'Sword and shield' },
        { id: '2272261736', desc: 'I Has Bucket Gear' },
        { id: '2740683110', desc: 'Green periastron (no shield)' },
        { id: '689873923', desc: 'Bone (makes character invisible like ghost burger)' },
        { id: '603307161', desc: 'More knives' },
        { id: '553351465', desc: '"Fixxed" Orbital Piano (broken)' },
        { id: '560368801', desc: "Bomb that can't deploy" },
        { id: '2813746381', desc: 'Harpoon' },
        { id: '564898488', desc: "FoxBin's healing magic (on gearwall)" },
        { id: '689871923', desc: 'LPI Cookie (squid game crossover)' },
        { id: '571337784', desc: 'More toy knife IDs' },
        { id: '830792338', desc: 'Nightmare Sword (looks like Terraria)' },
        { id: '2813714506', desc: 'Speed boost + catch on fire' },
        { id: '975022539', desc: 'Ultimate Rocket Pod (Banned - breaks gearwalls)' },
        { id: '965028875', desc: 'Staff of Noob (Banned)' },
        { id: '2785618375', desc: 'Spawns snakes that attack' },
        { id: '830806924', desc: 'Shoots local projecticles (no damage)' },
        { id: '836286179', desc: 'Certainly a sword' },
        { id: '2813761484', desc: 'Spawns massive christmas ornaments' },
        { id: '583347381', desc: '"I\'m feeling sick" gear (more range)' },
        { id: '4532316047', desc: 'Nerfed black hole sword' },
        { id: '75496631', desc: 'Chicken gear (probably useless)' },
        { id: '82596339', desc: "Weapons (don't work/no damage)" },
        { id: '93656513', desc: 'Hammer that disappears' },
        { id: '93652837', desc: 'Same as above' },
        { id: '1420976503', desc: 'Two Seat Rainbow Carpet (FoxBin version)' },
        { id: '1305359656', desc: 'Spawns hands that attach to players' },
        { id: '2268724392', desc: 'Gear that steals inventories' },
        { id: '1302058676', desc: 'FE Resize tool (F3X better)' },
        { id: '553345360', desc: 'Weird sword' },
        { id: '689870778', desc: 'Shoots immobile lasers' },
        { id: '905396790', desc: 'Import tool (blacklisted)' },
        { id: '606144853', desc: 'Liquid sword (not white)' },
        { id: '1319218306', desc: 'Platform Bow from gamepass' },
        { id: '5597966760', desc: 'Throwable Poisoned Chocolate' },
        { id: '606170157', desc: 'Spawns noobs quickly (despawn after time)' },
        { id: '2813692280', desc: 'Another throwable poison cake' },
        { id: '964370969', desc: "FoxBin's The Piece Maker (Banned)" },
        { id: '1405838300', desc: 'Broken delete tool' },
        { id: '2785562508', desc: 'Broken anime staff' },
        { id: '3017620592', desc: 'Removes your arm (glitch gateway)' },
        { id: '830818871', desc: 'Same as above (different ID)' },
        { id: '5069674434', desc: 'Hunting machete' },
        { id: '830809571', desc: 'Rainbow Katana' },
        { id: '1565221455', desc: 'Glitched sword (funny when spinning)' },
        { id: '1405883639', desc: 'Magic carpet (FoxBin version)' },
        { id: '689874950', desc: 'LPI Money Bag' },
        { id: '2785599053', desc: 'Revolver' },
        { id: '553350197', desc: 'Even more knives (FoxBin obsessed)' },
        { id: '553348895', desc: 'Boombox' }
    ],
    building: [
        { id: '3110755182', desc: 'Checkpoint (prevents death)' },
        { id: '831099294', desc: 'Old LPI hat dispenser' },
        { id: '560416757', desc: 'Brick wall for building' },
        { id: '900103501', desc: 'Old special bricks' },
        { id: '606154974', desc: "LPI Wrench's noob" },
        { id: '1547634015', desc: "LPI Wrench's spawn" },
        { id: '560414963', desc: 'Dummy near F3X giver (useless)' },
        { id: '560414641', desc: 'Black btools giver (F3X editable)' },
        { id: '4805640186', desc: 'Touch To Play ID block' },
        { id: '722474273', desc: 'Red wedge' },
        { id: '906768224', desc: 'Checkerboard pattern part (resizable)' },
        { id: '1554213924', desc: 'Jumppower changer' },
        { id: '660926908', desc: 'Thin white part' },
        { id: '660931809', desc: 'Brown part (2 invisible sides, no recolor)' },
        { id: '720541990', desc: 'Gives armor (changeable mesh)' },
        { id: '707234890', desc: 'Noob from Woa Badge' },
        { id: '67994803', desc: 'Concrete block' },
        { id: '67994759', desc: 'Log' },
        { id: '67994775', desc: 'Wood' },
        { id: '67994743', desc: 'Gravel' },
        { id: '67994740', desc: 'Granite' },
        { id: '67994731', desc: 'Gold' },
        { id: '67994724', desc: 'Cinder' },
        { id: '67994719', desc: 'Cement' },
        { id: '67994712', desc: 'Asphalt' },
        { id: '67994706', desc: 'Aluminum' },
        { id: '67625712', desc: 'Zombie Spawner' },
        { id: '67187816', desc: "Gift that can't be opened" },
        { id: '67187806', desc: 'Christmas tree (Merry Christmas!)' },
        { id: '67187797', desc: 'Christmas garland' },
        { id: '67187780', desc: 'Snowman' },
        { id: '67187771', desc: 'Menorah' },
        { id: '65962665', desc: 'Brick block' },
        { id: '65962645', desc: 'Granite block' },
        { id: '65943300', desc: "It's a COCK! Literally" },
        { id: '65894507', desc: 'Concrete with blue carpet' },
        { id: '65894286', desc: 'Refrigerator' },
        { id: '65820169', desc: 'Button on stand (sick)' },
        { id: '65820129', desc: 'Magic ball (particles on/off click)' },
        { id: '65820095', desc: 'Glitched Float Pad' },
        { id: '65820060', desc: 'Float pad from LPI Wrench' },
        { id: '65820011', desc: 'Energy core (cool for sci-fi)' },
        { id: '65819994', desc: "C4 (doesn't explode)" },
        { id: '67625690', desc: 'Tesla' },
        { id: '56446583', desc: 'Space Hatch' },
        { id: '67572398', desc: 'Timer (cosmetic only)' },
        { id: '67572390', desc: 'Builderman portrait' },
        { id: '67572320', desc: 'Blue concrete block' },
        { id: '67572258', desc: 'Awesome door (doesn\'t open)' },
        { id: '67572237', desc: 'Light switch (works, not hookable)' },
        { id: '67572224', desc: 'Laser (anchor & rotate up first)' },
        { id: '67572213', desc: 'Ugly circular door (doesn\'t open)' },
        { id: '86374494', desc: 'Meteor' },
        { id: '84929999', desc: 'Tiny crystal mountain' },
        { id: '82717697', desc: 'Blue powdered concrete (Minecraft-like)' },
        { id: '115744762', desc: 'Black block' },
        { id: '115744374', desc: 'Brown block' },
        { id: '115742827', desc: 'Yellow block' },
        { id: '113855979', desc: 'Bloxy cola vending machine (gamepass broken)' },
        { id: '121359440', desc: 'Massive undeletable grey baseplate' },
        { id: '844842315', desc: 'Spawns water at fixed coordinate' },
        { id: '701375439', desc: 'Spawns huge brick (deletable)' },
        { id: '69281349', desc: 'Pressure Plate' },
        { id: '69281292', desc: 'Radio (probably broken)' },
        { id: '69281057', desc: 'Speaker (cosmetic only)' },
        { id: '69281032', desc: 'Clickable button (changes color)' },
        { id: '23153972', desc: 'Park Bench' },
        { id: '69276460', desc: 'Drawbridge gate' },
        { id: '69939157', desc: 'Catapult model (doesn\'t work)' },
        { id: '90719419', desc: 'Part with stone fist mesh' },
        { id: '81047202', desc: 'Weird pillar thing' },
        { id: '80568507', desc: 'Weird pillar (another ID)' },
        { id: '105292979', desc: 'Weird thing carrying a cat' },
        { id: '134082409', desc: 'Grave' },
        { id: '125896025', desc: 'Taxi (useful for city builds)' },
        { id: '123227932', desc: 'Percy Jackson Billboards' },
        { id: '65819947', desc: 'Weird thing with "delay" text' },
        { id: '161865355', desc: 'How to train your dragon Billboards' },
        { id: '160802655', desc: 'Fireworks + pressure plate activator' },
        { id: '160802555', desc: 'Same as above' },
        { id: '160802395', desc: 'Same as above the above' },
        { id: '1554225939', desc: 'Walkspeed Pad' },
        { id: '560414250', desc: "Music player (can't insert music)" },
        { id: '599157629', desc: 'Mini island with dog (secret island texts)' },
        { id: '560415640', desc: '4 white platforms + invisible things' },
        { id: '1550671308', desc: 'LPI Wrench radio (spawns above void)' },
        { id: '727371256', desc: 'Unanchored island thing (3 canes + guy)' },
        { id: '564913728', desc: 'Fog (can\'t remove it)' },
        { id: '3028786688', desc: 'Moonlit (cool for magical builds)' },
        { id: '903319803', desc: 'Killbricks' },
        { id: '952149606', desc: 'Text generator (can\'t input text, moveable)' },
        { id: '560417137', desc: 'Roblox house' },
        { id: '709637497', desc: 'Bricks with particles (waterfalls/piss, breaks on import)' },
        { id: '709640183', desc: 'Water effect (really cool)' },
        { id: '1547789663', desc: 'Gear giver from wrench' },
        { id: '606149729', desc: 'Another noob from wrench ID' },
        { id: '569806399', desc: 'Castle of Bronze (move from spawn)' },
        { id: '847345299', desc: 'Terrain blocks' },
        { id: '1554780073', desc: 'Teleporters (on LPI Wrench)' }
    ],
    scripts: [
        { id: '1367834043', desc: 'Fancy black text on screen (useless)' },
        { id: '560419694', desc: 'Sprint Script (possibly broken)' },
        { id: '560419913', desc: 'Ragdoll on death' },
        { id: '923894226', desc: 'View bobbing (needs testing)' },
        { id: '2272946427', desc: 'R15 for all joining players' },
        { id: '1992619355', desc: 'R11 (unknown if works)' },
        { id: '649769709', desc: 'Could give 1000 HP Gamepass' },
        { id: '1025849174', desc: 'TimeAPI - shows time for all' },
        { id: '557018820', desc: 'it was a great time... I love you' },
        { id: '775764753', desc: 'Smooth camera (needs testing)' },
        { id: '560421884', desc: 'Double jump (reset to work)' },
        { id: '846089351', desc: 'Removes water and terrain' },
        { id: '561238759', desc: 'Minecraft Name Tags' },
        { id: '977181407', desc: 'Fake chat bubble (unknown how)' },
        { id: '923651590', desc: 'Might give shiftlock (needs testing)' }
    ],
    npcs: [
        { id: '187790284', desc: 'Soldier NPC' },
        { id: '72648316', desc: 'Massive NPC' },
        { id: '71536048', desc: 'Monkey N(FT)PC' },
        { id: '71006520', desc: 'Genie NPC' },
        { id: '69489068', desc: 'Alien NPC' },
        { id: '68452456', desc: 'NPC with animation' },
        { id: '82264079', desc: 'Alien dog' },
        { id: '3924229481', desc: 'Robot NPCS' },
        { id: '93601062', desc: 'Roblox zombie' },
        { id: '95401558', desc: 'Black smoke figure (fast, little damage)' },
        { id: '94251705', desc: 'White figure (no smoke)' },
        { id: '94316174', desc: 'Undeletable dragon (Rail Runner removes wings)' },
        { id: '93746797', desc: 'Doll in the sky' },
        { id: '88117081', desc: 'Goblin NPC (sick haircut)' },
        { id: '87350670', desc: 'Chimera NPC' },
        { id: '67629734', desc: 'Zombie from zombie spawner' },
        { id: '76117301', desc: 'Parasite NPC' },
        { id: '101713896', desc: 'Blue dragon (disappears after seconds)' },
        { id: '106808835', desc: 'Frog' },
        { id: '713405635', desc: 'More zombies' },
        { id: '121605203', desc: 'Zombie dog' },
        { id: '124120704', desc: 'Dummy' },
        { id: '124120649', desc: 'More dummy' },
        { id: '159856065', desc: 'Dragon flies to 0,0 and does nothing' },
        { id: '158186284', desc: 'Same dragon (broken wing, doesn\'t fly)' },
        { id: '964882209', desc: 'Noob from Noob Staff (spawns above void)' },
        { id: '516159357', desc: 'Grey NPC with R15' },
        { id: '623140790', desc: 'Noob Fighter Bot' },
        { id: '623120557', desc: 'Bot Fighting Bot' },
        { id: '623157745', desc: 'Foxbin Fighter bot' },
        { id: '623160582', desc: 'Bluedogz Fighter Bot' },
        { id: '623120029', desc: 'Bluedogz Fighter Bot' },
        { id: '713622333', desc: 'Spawns 3 different zombies' },
        { id: '1406577583', desc: 'LPI Anthro NPC' },
        { id: '713421604', desc: 'Zombie' },
        { id: '2282122675', desc: 'Character with infinite forcefield + animations' },
        { id: '623168775', desc: 'Masterhalo012 Fighter Bot' },
        { id: '623123830', desc: 'Masterhalo012 Fighter Bot' },
        { id: '623116750', desc: 'orinrino619 Fighter Bot' },
        { id: '701379301', desc: 'Zombie Template (spawns over void, instakill)' }
    ],
    badges: [
        { id: '518117856', desc: 'Badge giver (doesn\'t work)' },
        { id: '576582129', desc: 'Badge giver (doesn\'t work)' },
        { id: '576583303', desc: 'Badge giver (doesn\'t work)' },
        { id: '475811560', desc: 'Blacklisted badge' },
        { id: '538899036', desc: 'Badge giver (doesn\'t work)' },
        { id: '509577032', desc: 'Badge giver (doesn\'t work)' },
        { id: '507487979', desc: 'Badge giver (doesn\'t work)' },
        { id: '484479325', desc: 'Badge giver (doesn\'t work)' },
        { id: '563365537', desc: 'Badge giver (doesn\'t work)' },
        { id: '521091099', desc: 'Badge giver (doesn\'t work)' },
        { id: '538900217', desc: 'Badge giver (doesn\'t work)' },
        { id: '576582558', desc: 'Badge giver (doesn\'t work)' },
        { id: '576582869', desc: 'Badge giver (doesn\'t work)' },
        { id: '509577177', desc: 'Badge giver (doesn\'t work)' },
        { id: '507488008', desc: 'Badge giver (doesn\'t work)' },
        { id: '509730244', desc: 'Badge giver (doesn\'t work)' },
        { id: '507487878', desc: 'Badge giver (doesn\'t work)' },
        { id: '538900100', desc: 'Badge giver (doesn\'t work)' },
        { id: '67315342', desc: 'Badge giver (doesn\'t work)' },
        { id: '508603771', desc: 'Badge giver (doesn\'t work)' },
        { id: '576583422', desc: 'Badge giver (doesn\'t work)' },
        { id: '500543761', desc: 'Badge giver (doesn\'t work)' },
        { id: '509576797', desc: 'Badge giver (doesn\'t work)' },
        { id: '518265447', desc: 'Badge giver (doesn\'t work)' },
        { id: '896724302', desc: 'Badge giver (doesn\'t work)' }
    ],
    cars: [
        { id: '6433316269', desc: 'Vans' },
        { id: '6433330180', desc: 'Super Cars' },
        { id: '6418225759', desc: 'Pick up Trucks' },
        { id: '6418234850', desc: 'SUVs' },
        { id: '6418221666', desc: 'Jeeps' },
        { id: '6433272094', desc: 'Dune Buggies' },
        { id: '6433323089', desc: 'Sport Cars' },
        { id: '6418239833', desc: 'Sedans' }
    ]
};

codes.custom = customCodes;

let currentCategory = 'all';
let searchTerm = '';

function renderCodes() {
    const content = document.getElementById('content');
    content.innerHTML = '';
    let visibleCount = 0;
    let totalCount = 0;

    Object.keys(codes).forEach(category => {
        totalCount += codes[category].length;
        
        for(let i = 0; i < codes[category].length; i++) {
            if (currentCategory !== 'all' && currentCategory !== category) return;
            const code = codes[category][category==="custom"?codes[category].length-i-1:i];
            if (searchTerm && !code.id.includes(searchTerm) && !code.desc.toLowerCase().includes(searchTerm.toLowerCase())) return;

            visibleCount++;
            
            const card = document.createElement('div');
            card.className = 'code-card';
            if (category === 'custom') {
                card.classList.add('custom');
            }
            
            const header = document.createElement('div');
            header.className = 'code-header';
            
            const categoryBadge = document.createElement('span');
            categoryBadge.className = 'category-badge';
            categoryBadge.textContent = getCategoryName(category);
            header.appendChild(categoryBadge);
            
            const codeId = document.createElement('div');
            codeId.className = 'code-id';
            
            const codeIdText = document.createElement('span');
            codeIdText.className = 'code-id-text';
            codeIdText.textContent = code.id;
            
            const copyBtn = document.createElement('button');
            copyBtn.className = 'copy-btn';
            copyBtn.textContent = 'COPY';
            copyBtn.addEventListener('click', function(e) {
                e.stopPropagation();
                navigator.clipboard.writeText(code.id).then(() => {
                    copyBtn.textContent = 'COPIED!';
                    copyBtn.style.background = 'var(--matrix-green)';
                    copyBtn.style.color = '#000';
                    setTimeout(() => {
                        copyBtn.textContent = 'COPY';
                        copyBtn.style.background = 'transparent';
                        copyBtn.style.color = 'var(--cyber-blue)';
                    }, 1500);
                });
            });
            
            codeId.appendChild(codeIdText);
            codeId.appendChild(copyBtn);
            
            if (category === 'custom') {
                const deleteBtn = document.createElement('button');
                deleteBtn.className = 'delete-btn';
                deleteBtn.textContent = 'DELETE';
                deleteBtn.addEventListener('click', function(e) {
                    e.stopPropagation();
                    deleteCustomCode(code.id);
                });
                codeId.appendChild(deleteBtn);
            }
            
            const desc = document.createElement('div');
            desc.className = 'code-description';
            desc.textContent = code.desc;
            
            card.appendChild(header);
            card.appendChild(codeId);
            card.appendChild(desc);
            content.appendChild(card);
        }
    });

    if (visibleCount === 0) {
        content.innerHTML = `
            <div class="no-results">
                <h2>⚠ NO DATA FOUND</h2>
                <p>> Adjust search parameters and try again</p>
            </div>
        `;
    }

    document.getElementById('totalCodes').textContent = totalCount;
    document.getElementById('visibleCodes').textContent = visibleCount;
    document.getElementById('categoryCount').textContent = Object.keys(codes).length;
    document.getElementById('customCount').textContent = codes.custom ? codes.custom.length : 0;
}

function getCategoryName(category) {
    const names = {
        cords: 'COORDINATES',
        misc: 'MISCELLANEOUS',
        music: 'AUDIO FILES',
        gears: 'WEAPONS/GEAR',
        building: 'CONSTRUCTION',
        scripts: 'SCRIPTS/CODE',
        npcs: 'NPCS/BOTS',
        badges: 'BADGES',
        cars: 'VEHICLES',
        custom: 'CUSTOM INJECTIONS'
    };
    return names[category] || category.toUpperCase();
}

function isDuplicateId(id) {
    for (const category in codes) {
        const exists = codes[category].some(code => code.id === id.trim());
        if (exists) return true;
    }
    return false;
}

function addCustomCode(id, desc) {
    if (!id.trim() || !desc.trim()) {
        alert('> ERROR: BOTH ID AND DESCRIPTION REQUIRED');
        return;
    }

    if (isDuplicateId(id)) {
        alert('> ERROR: ID ALREADY EXISTS IN DATABASE');
        return;
    }

    const newCode = { id: id.trim(), desc: desc.trim() };
    codes.custom.push(newCode);
    
    localStorage.setItem('lpiCustomCodes', JSON.stringify(codes.custom));
    
    document.getElementById('customIdInput').value = '';
    document.getElementById('customDescInput').value = '';
    
    document.querySelectorAll('.category-btn').forEach(b => b.classList.remove('active'));
    document.querySelector('[data-category="custom"]').classList.add('active');
    currentCategory = 'custom';
    renderCodes();
    
    document.querySelector('.add-custom').style.animation = 'glitch 0.3s';
    setTimeout(() => {
        document.querySelector('.add-custom').style.animation = '';
    }, 300);
}

function deleteCustomCode(id) {
    if (confirm('> CONFIRM DELETION OF CUSTOM INJECTION?')) {
        codes.custom = codes.custom.filter(code => code.id !== id);
        localStorage.setItem('lpiCustomCodes', JSON.stringify(codes.custom));
        renderCodes();
    }
}

document.querySelectorAll('.category-btn').forEach(btn => {
    btn.addEventListener('click', function() {
        document.querySelectorAll('.category-btn').forEach(b => b.classList.remove('active'));
        this.classList.add('active');
        currentCategory = this.dataset.category;
        renderCodes();
        
        this.style.animation = 'glitch 0.2s';
        setTimeout(() => {
            this.style.animation = '';
        }, 200);
    });
});

document.getElementById('searchInput').addEventListener('input', function(e) {
    searchTerm = e.target.value;
    renderCodes();
});

document.getElementById('addCustomBtn').addEventListener('click', function() {
    const idInput = document.getElementById('customIdInput');
    const descInput = document.getElementById('customDescInput');
    addCustomCode(idInput.value, descInput.value);
});

document.getElementById('customIdInput').addEventListener('keypress', function(e) {
    if (e.key === 'Enter') {
        document.getElementById('addCustomBtn').click();
    }
});

document.getElementById('customDescInput').addEventListener('keypress', function(e) {
    if (e.key === 'Enter') {
        document.getElementById('addCustomBtn').click();
    }
});

createMatrixRain();

renderCodes();

setInterval(() => {
    const header = document.querySelector('.header h1');
    header.style.animation = 'glitch 0.5s';
    setTimeout(() => {
        header.style.animation = '';
    }, 500);
}, 10000);

setInterval(() => {
    const randomStat = document.querySelectorAll('.stat-card')[Math.floor(Math.random() * 4)];
    randomStat.style.opacity = '0.7';
    setTimeout(() => {
        randomStat.style.opacity = '1';
    }, 100);
}, 3000);
