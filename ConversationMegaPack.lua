local FC = _G.ForeverCompanion

local function pool(topic)
    FC.dialogue.Vexa[topic] = FC.dialogue.Vexa[topic] or {}
    return FC.dialogue.Vexa[topic]
end

local function add(topic, lines)
    local p = pool(topic)
    for _, line in ipairs(lines or {}) do p[#p + 1] = line end
end

local function cross(topic, starts, endings)
    local p = pool(topic)
    for _, a in ipairs(starts or {}) do
        for _, b in ipairs(endings or {}) do
            p[#p + 1] = a .. b
        end
    end
end

-- Short, public-domain/classic quotations. The wrappers multiply variety without changing the quotation.
local quotes = {
    'Shakespeare: "Brevity is the soul of wit."',
    'Shakespeare: "All the world’s a stage."',
    'Shakespeare: "To thine own self be true."',
    'Shakespeare: "The better part of valor is discretion."',
    'Shakespeare: "Cowards die many times before their deaths."',
    'Francis Bacon: "Knowledge itself is power."',
    'Francis Bacon: "Hope is a good breakfast, but it is a bad supper."',
    'Benjamin Franklin: "Well done is better than well said."',
    'Benjamin Franklin: "Lost time is never found again."',
    'Benjamin Franklin: "He that can have patience can have what he will."',
    'Benjamin Franklin: "Energy and persistence conquer all things."',
    'Abraham Lincoln: "Whatever you are, be a good one."',
    'Abraham Lincoln: "I will prepare and someday my chance will come."',
    'Ralph Waldo Emerson: "Nothing great was ever achieved without enthusiasm."',
    'Ralph Waldo Emerson: "Hitch your wagon to a star."',
    'Henry David Thoreau: "Go confidently in the direction of your dreams."',
    'Henry David Thoreau: "The price of anything is the amount of life you exchange for it."',
    'Oscar Wilde: "Experience is simply the name we give our mistakes."',
    'Oscar Wilde: "Be yourself; everyone else is already taken."',
    'Oscar Wilde: "We are all in the gutter, but some of us are looking at the stars."',
    'Mark Twain: "The secret of getting ahead is getting started."',
    'Mark Twain: "Courage is resistance to fear, mastery of fear—not absence of fear."',
    'Mark Twain: "Kindness is the language which the deaf can hear and the blind can see."',
    'Charles Dickens: "No one is useless in this world who lightens the burden of another."',
    'Charles Dickens: "There is nothing in the world so irresistibly contagious as laughter."',
    'Jane Austen: "There is no charm equal to tenderness of heart."',
    'Jane Austen: "Think only of the past as its remembrance gives you pleasure."',
    'Thomas Jefferson: "I’m a great believer in luck, and I find the harder I work the more I have of it."',
    'Thomas Edison: "Genius is one percent inspiration and ninety-nine percent perspiration."',
    'Michelangelo: "I am still learning."',
    'Socrates: "The unexamined life is not worth living."',
    'Socrates: "Wonder is the beginning of wisdom."',
    'Aristotle: "We are what we repeatedly do."',
    'Aristotle: "The roots of education are bitter, but the fruit is sweet."',
    'Epictetus: "No man is free who is not master of himself."',
    'Epictetus: "First say to yourself what you would be; and then do what you have to do."',
    'Seneca: "Luck is what happens when preparation meets opportunity."',
    'Seneca: "Difficulties strengthen the mind, as labor does the body."',
    'Seneca: "While we are postponing, life speeds by."',
    'Laozi: "A journey of a thousand miles begins beneath one’s feet."',
    'Confucius: "It does not matter how slowly you go as long as you do not stop."',
    'Confucius: "Our greatest glory is not in never falling, but in rising every time we fall."',
    'Sun Tzu: "In the midst of chaos, there is also opportunity."',
    'Sun Tzu: "Victorious warriors win first and then go to war."',
    'Leonardo da Vinci: "Simplicity is the ultimate sophistication."',
    'Leonardo da Vinci: "Learning never exhausts the mind."',
    'Alexander Pope: "To err is human; to forgive, divine."',
    'Alexander Pope: "A little learning is a dangerous thing."',
    'Samuel Johnson: "Great works are performed not by strength but by perseverance."',
    'Goethe: "Knowing is not enough; we must apply. Willing is not enough; we must do."',
    'Voltaire: "Judge a man by his questions rather than by his answers."',
    'Voltaire: "Perfect is the enemy of good."',
    'Plutarch: "The mind is not a vessel to be filled, but a fire to be kindled."',
    'Cicero: "Gratitude is not only the greatest of virtues, but the parent of all the others."',
    'Descartes: "I think, therefore I am."',
    'Pascal: "The heart has its reasons which reason knows nothing of."',
    'John Milton: "The mind is its own place."',
    'John Donne: "No man is an island."',
    'William Blake: "The road of excess leads to the palace of wisdom."',
    'Emily Dickinson: "Forever is composed of nows."',
    'Walt Whitman: "Keep your face always toward the sunshine—and shadows will fall behind you."',
    'Robert Louis Stevenson: "To travel hopefully is a better thing than to arrive."',
    'Lewis Carroll: "If you don’t know where you are going, any road will get you there."',
    'Aesop: "No act of kindness, no matter how small, is ever wasted."',
    'Aesop: "Slow and steady wins the race."',
    'Aesop: "Appearances are often deceiving."',
}

local quoteStarts = {
    "Quote break. ", "Something old and good: ", "Tiny bit of wisdom: ", "I found one for you: ",
    "Since we're walking, here's one: ", "Random classic quote: ", "Vexa's unsolicited literature hour: ",
    "All right, listen to this one: ", "This seems appropriate: ", "I like this one: ",
}
for _, q in ipairs(quotes) do
    for _, s in ipairs(quoteStarts) do pool("famousquote")[#pool("famousquote") + 1] = s .. q end
end

local scienceFacts = {
    "octopuses have three hearts and blue blood.",
    "honey can remain edible for an astonishingly long time when sealed properly.",
    "a day on Venus is longer than a year on Venus.",
    "sharks existed before trees.",
    "bananas are berries, botanically speaking, while strawberries are not.",
    "the Eiffel Tower can grow taller in hot weather because metal expands.",
    "water can boil and freeze at the same time under the right pressure.",
    "light from the Sun takes a little over eight minutes to reach Earth.",
    "a teaspoon of neutron-star material would weigh billions of tons on Earth.",
    "the Moon is slowly drifting away from Earth.",
    "some turtles can breathe through specialized tissues near their rear ends.",
    "a group of flamingos is called a flamboyance.",
    "sea otters sometimes hold hands while resting so they do not drift apart.",
    "wombat droppings can be cube-shaped.",
    "crows can recognize individual human faces.",
    "ravens can solve multi-step problems and remember solutions.",
    "dolphins use signature whistles that function a little like names.",
    "elephants can distinguish some human languages by sound.",
    "some frogs can survive being partially frozen.",
    "wood frogs can stop their hearts during winter freezing and restart in spring.",
    "a cloud can weigh hundreds of tons despite floating overhead.",
    "the deepest ocean trenches are deeper than Mount Everest is tall.",
    "there are lakes hidden beneath Antarctica's ice sheet.",
    "Earth is not a perfect sphere; it bulges slightly at the equator.",
    "Saturn would float in a sufficiently large body of water because its average density is lower than water.",
    "the Great Red Spot on Jupiter is a storm larger than Earth.",
    "Mars has the largest volcano in the solar system, Olympus Mons.",
    "Mercury experiences enormous temperature swings between day and night.",
    "the human brain uses roughly a fifth of the body's energy at rest.",
    "your bones are constantly being broken down and rebuilt by living cells.",
    "the cornea gets oxygen directly from the air rather than from blood vessels.",
    "your body contains more bacterial cells than most people expect, especially in the gut.",
    "a sneeze is a coordinated reflex involving far more muscles than it feels like.",
    "your ears and nose appear to change shape with age partly because cartilage changes over time.",
    "DNA in a single human cell is roughly two meters long if stretched out.",
    "red blood cells normally circulate for around four months before being replaced.",
    "the smallest bones in the human body are in the middle ear.",
    "the human body gives off a tiny amount of visible light too faint for our eyes to see.",
    "glass is an amorphous solid, not a liquid slowly flowing at room temperature.",
    "lightning can heat the air around it to temperatures hotter than the surface of the Sun.",
    "the smell after rain has a name: petrichor.",
    "sound travels faster in water than in air.",
    "hot water can sometimes freeze faster than colder water under specific conditions, called the Mpemba effect.",
    "some metals can remember their original shape after being bent when heated.",
    "a properly shuffled deck of cards is extraordinarily likely to be in an order never seen before.",
    "there are more possible chess games than atoms in the observable universe by common estimates.",
    "a standard sheet of paper cannot be folded in half indefinitely because thickness doubles each fold.",
    "the number zero took a surprisingly long time to become a standard mathematical concept.",
    "prime numbers continue forever; there is no largest prime.",
    "a Möbius strip has only one side and one boundary curve.",
    "the dot over a lowercase i or j is called a tittle.",
    "the word 'alphabet' comes from the first two Greek letters, alpha and beta.",
    "the ampersand symbol began as a ligature of the Latin word 'et,' meaning 'and.'",
    "the word 'robot' comes from a Czech word related to forced labor.",
    "many everyday English words traveled through several languages before reaching modern English.",
}

local factStarts = {
    "Random science fact: ", "You didn't ask, but: ", "Tiny brain snack: ", "Here's something weird: ",
    "Walking fact: ", "Useful? Maybe not. Interesting? Yes: ", "Vexa fact delivery: ", "I learned this and now you have to know it too: ",
    "One for the road: ", "Odd little fact: ",
}
for _, f in ipairs(scienceFacts) do
    for _, s in ipairs(factStarts) do pool("sciencefact")[#pool("sciencefact") + 1] = s .. f end
end

local historyFacts = {
    "Oxford University was already teaching students before the Aztec Empire was founded.",
    "Cleopatra lived closer in time to the Moon landing than to the construction of the Great Pyramid of Giza.",
    "the Roman Empire and ancient China maintained long-distance trade links indirectly through the Silk Road.",
    "Vikings reached North America centuries before Columbus's voyages.",
    "the printing press transformed Europe partly because books became dramatically cheaper to reproduce.",
    "the Library of Alexandria was damaged over multiple events rather than vanishing in one single dramatic fire.",
    "Napoleon was around average height for a French man of his era; the 'very short' image is exaggerated.",
    "the shortest recorded war, between Britain and Zanzibar in 1896, lasted less than an hour.",
    "ancient Romans used concrete in structures that have survived for nearly two thousand years.",
    "the first known vending-machine-like device was described in ancient Alexandria and dispensed holy water.",
    "the word 'salary' is related to the Latin word for salt, though the popular claim that Romans were literally paid in salt is oversimplified.",
    "samurai and European knights overlapped in history for centuries.",
    "the fax machine was invented before the American Civil War.",
    "the first photograph required an exposure lasting hours.",
    "the first powered airplane flight lasted less than a minute.",
    "the first successful undersea telegraph cables helped shrink communication times across oceans from weeks to minutes.",
    "maps used to include imaginary islands that remained on charts for generations before being disproven.",
    "pirates did use flags to intimidate targets, but the exact skull-and-crossbones design varied widely.",
    "medieval people did bathe; the idea that nobody bathed at all is a myth.",
    "some medieval manuscripts contain doodles and jokes in their margins.",
    "ancient graffiti has been found containing complaints, jokes, boasts, and political messages.",
    "the Great Wall of China is not visible from the Moon with the naked eye.",
    "the Statue of Liberty's copper surface was originally brown before oxidizing green.",
    "the first modern Olympics were held in Athens in 1896.",
    "the Gregorian calendar was introduced because the older Julian calendar drifted against the solar year.",
    "paper money was used in China centuries before it became common in Europe.",
    "coffeehouses became important centers of discussion, business, and politics in early modern Europe.",
    "tea was once so valuable in Europe that it was commonly kept under lock and key.",
    "buttons existed as decoration long before buttonholes made them practical fasteners.",
    "forks took centuries to become widely accepted in parts of Europe.",
    "the earliest known board games are thousands of years old.",
    "dice-like objects have been found in ancient archaeological sites across several civilizations.",
    "the word 'deadline' had a grim literal meaning during the American Civil War before becoming a work term.",
    "the first public museums grew from private collections opened to broader audiences.",
    "modern time zones became much more important once railroads made local solar time impractical.",
    "the first traffic lights appeared before most people owned cars.",
    "the London Underground began operating in the nineteenth century.",
    "the first practical typewriters changed office work and professional writing dramatically.",
    "many famous city street grids were designed long before modern cars existed.",
    "the term 'computer' once referred to people whose job was performing calculations.",
}
local historyStarts = {
    "History tangent: ", "Random history thing: ", "Since we're wandering anyway: ", "I love this one: ",
    "Old-world fact: ", "Tiny history detour: ", "Apparently humanity has always been weird: ", "One from the history shelf: ",
}
for _, f in ipairs(historyFacts) do
    for _, s in ipairs(historyStarts) do pool("historyfact")[#pool("historyfact") + 1] = s .. f end
end

local questionFrames = {
    "Question for you: ", "All right, answer this in your head: ", "Random question: ", "I need your ruling on something: ",
    "Important research question: ", "No wrong answer... probably: ", "While we're here, ", "You have ten seconds to decide: ",
    "Vexa interview time: ", "One of life's smaller questions: ",
}
local questions = {
    "if you could instantly master one real-world skill, what would you pick?",
    "if you could live in any fictional city for one year, where would you go?",
    "what is one food you could eat every week and never get tired of?",
    "if you had to pick one season forever, which one wins?",
    "what game would you erase from your memory just so you could experience it fresh again?",
    "if you could have one harmless superpower, what would actually improve your life most?",
    "what is the most underrated sound in the world?",
    "if money and time disappeared as constraints for a month, what would you do first?",
    "which fictional weapon would you keep purely because it looks cool?",
    "if you could ask your future self one question, what would it be?",
    "what is a tiny luxury you would hate to give up?",
    "if you had to teach a class about something tomorrow, what topic could you survive?",
    "what is a place you would revisit instantly if travel took zero time?",
    "if you could become fluent in one language overnight, which one?",
    "what hobby looks fun but you know would consume your entire personality?",
    "if you could keep one age forever physically, what age would you choose?",
    "what movie can you rewatch without getting annoyed by it?",
    "if every day had one extra hour, where would yours actually go?",
    "what is the best smell that is not food?",
    "if you could have dinner with one person from history, who gets the invite?",
    "what is one thing everyone should try once?",
    "if you had to rename your character right now, what would you choose?",
    "which class fantasy would you want in real life if the dangerous parts were removed?",
    "what fictional pet would you adopt immediately?",
    "what is one game mechanic you wish existed in real life?",
    "if your life had loading-screen tips, what would one of them say?",
    "what is the dumbest purchase that still made you happy?",
    "if you could teleport to exactly one fixed location forever, where would you anchor it?",
    "what is one skill you respect even though you have no desire to learn it?",
    "what is the funniest thing that reliably makes you laugh?",
    "if you could guarantee perfect weather for one kind of day, what day would you save it for?",
    "what is your personal sign that a day went well?",
    "if you could replay one ordinary day from your past, which one would you pick?",
    "what is a totally useless fact you are weirdly glad you know?",
    "which creature in Azeroth would be the worst roommate?",
    "which WoW zone would make the best vacation if nothing attacked you?",
    "which class would be the most annoying coworker?",
    "if gold were real money, what would your current character immediately waste it on?",
    "what is your favorite kind of weather when you have nowhere to be?",
    "if you had to choose between perfect memory and perfect focus, which one wins?",
}
for _, q in ipairs(questions) do
    for _, s in ipairs(questionFrames) do pool("curiousquestion")[#pool("curiousquestion") + 1] = s .. q end
end

local optionA = {
    "have a hearthstone in real life", "always know exactly where you parked", "never need sleep", "never need to charge a device",
    "speak every language", "teleport once per day", "pause time for ten seconds", "always get the perfect parking spot",
    "have unlimited bag space", "never get stuck in traffic", "know the weather a week early", "have perfect aim when throwing anything",
    "understand every animal", "remember every name you hear", "never lose your keys", "always wake up fully rested",
    "have a real minimap", "see quest markers over people's heads", "have a real-life vendor buy all your junk", "gain skill points visibly",
    "have a 30-minute cooldown teleport", "instantly repair anything you own", "always know the fastest route", "never wait in a line",
    "have perfect cooking results", "never spill a drink", "always find the best restaurant nearby", "be immune to mosquitoes",
    "always know when someone is bluffing", "have background music that matches your mood",
}
local optionB = {
    "have a real mount you can summon anywhere", "never forget a password", "eat anything without consequences", "never wait for a download",
    "play every instrument", "fly for ten minutes per day", "rewind time by thirty seconds", "always find exact change",
    "have unlimited bank space", "never hit a red light", "know tomorrow's winning sports scores but never bet on them", "never miss a tossed object",
    "understand every human language but not animals", "never forget a face", "never lose your phone", "fall asleep instantly on command",
    "have floating nameplates", "see everyone's current mood as a colored icon", "have an auction house for household junk", "see your own progress bars",
    "open a portal once per week", "never break anything accidentally", "always know the scenic route", "always get the shortest checkout line",
    "have perfect coffee every morning", "never get crumbs in your keyboard", "always know the best item on a menu", "be immune to sunburn",
    "always know when you're being sold something", "have a narrator who comments on your choices",
}
local wr = pool("wouldyourather")
for i, a in ipairs(optionA) do
    for j, b in ipairs(optionB) do
        if i ~= j then wr[#wr + 1] = "Would you rather " .. a .. " or " .. b .. "?" end
    end
end

local thoughtStarts = {
    "Deep thought, allegedly: ", "This may sound smarter than it is, but ", "Tiny philosophy break: ", "I was thinking: ",
    "Consider this: ", "Vexa wisdom, free of charge: ", "One thing I've noticed: ", "Here is my completely unsolicited theory: ",
    "Maybe the real trick is that ", "I suspect that ", "Something worth remembering: ", "Quiet thought: ",
}
local thoughtEnds = {
    "consistency is often more impressive than intensity because anyone can be intense for five minutes.",
    "people underestimate how much easier a hard thing becomes once it turns into a routine.",
    "the best plans usually leave room for reality to be annoying.",
    "confidence works best when it has evidence behind it.",
    "being curious gets you surprisingly far before being brilliant becomes necessary.",
    "small wins matter because momentum is a real thing even when nobody can put it in a bag.",
    "rest is useful when it helps you return sharper instead of merely delaying the next step.",
    "a good question can save more time than a fast answer.",
    "progress is easier to notice when you occasionally look backward instead of only forward.",
    "the difference between persistence and stubbornness is whether you're still learning.",
    "a little humor makes repetitive work much easier to survive.",
    "most people are better at adapting than they give themselves credit for.",
    "you do not need perfect motivation if you have a decent system.",
    "sometimes the smart move is simply doing the obvious thing before inventing a clever one.",
    "attention is probably one of the most valuable resources nobody thinks of as a currency.",
    "you can learn a lot about someone by what they do when nobody is keeping score.",
    "being wrong quickly is often more useful than being vaguely right for a long time.",
    "a problem usually gets less scary once it has a name and a next step.",
    "there is a strange freedom in deciding that not every opinion deserves your energy.",
    "skills look like talent from far away because nobody sees the boring repetitions.",
    "a good habit is basically automation for a human being.",
    "you rarely regret preparing too early, but you frequently regret starting too late.",
    "the fastest route is not always the one that feels fastest moment to moment.",
    "people remember how a moment felt longer than they remember the exact details.",
    "if you can laugh at a bad attempt, you are much more likely to make a second attempt.",
    "the easiest way to make a huge goal less dramatic is to make today's version of it very small.",
    "there is no shame in changing a plan when new information shows up.",
    "good judgment is often just memory with better timing.",
    "boredom is occasionally your brain asking for novelty, and occasionally asking you to finish the thing you are avoiding.",
    "the things you repeat become your default long before they become your identity.",
    "a calm decision can still be an aggressive move if it changes the situation.",
    "there is a difference between moving slowly and standing still.",
    "you can respect a challenge without turning it into a crisis.",
    "sometimes improvement feels worse before it feels better because now you can see the mistakes clearly.",
    "the ability to reset after a bad stretch is a skill all by itself.",
    "good pacing beats heroic burnout in almost every long game.",
    "you can be proud of progress and still be dissatisfied with the current result.",
    "most difficult things become normal after enough repetitions, which is both comforting and slightly terrifying.",
    "the best kind of confidence is quiet because it does not need an audience.",
    "being prepared is just making future-you less annoyed with present-you.",
}
cross("deepthought", thoughtStarts, thoughtEnds)

local challengeStarts = {
    "Mini challenge: ", "Tiny challenge while we play: ", "Try this for the next few minutes: ", "Vexa challenge: ",
    "Low-stakes challenge: ", "If you want something to do besides killing things: ",
}
local challengeEnds = {
    "see if you can go ten minutes without opening a menu you did not actually need.",
    "finish the next objective before checking anything unrelated.",
    "pick one small thing you're avoiding and decide the first step before we stop moving.",
    "see if you can make the next three pulls clean with no unnecessary downtime.",
    "notice one thing in the environment you've probably run past a hundred times.",
    "guess how long the next level will take before looking at the estimate.",
    "try to remember the last three zones you leveled in without checking anything.",
    "pick a completely useless item in your bags and tell yourself why you're still carrying it.",
    "for the next five minutes, no tabbing out. Yes, I know what I said.",
    "find the funniest NPC name you can spot before the next objective completes.",
    "decide whether you're optimizing for speed or fun right now. Both is allowed, but choose one first.",
    "try to predict which quest will finish first before the tracker tells you.",
    "when the next good drop appears, guess the vendor value before checking it.",
    "finish one small real-life task the next time we hit a flight path or loading screen.",
    "pay attention to whether you're actually using your cooldowns or just saving them forever.",
    "watch for one enemy ability you usually ignore and see what it actually does.",
    "see how long you can keep a clean combat rhythm without stopping between pulls.",
    "pick one keybind that still feels awkward and consciously use it ten times.",
    "name one thing this character does better than your other characters.",
    "when we reach town, sell one thing you've been hoarding for no good reason.",
    "try one route choice based purely on curiosity instead of efficiency.",
    "notice the soundtrack for a full minute instead of mentally filtering it out.",
    "count how many different creatures we pass before the next quest update.",
    "decide your next three actions before doing the first one.",
    "see if you can end the next fight with more health than the previous one.",
}
cross("minichallenge", challengeStarts, challengeEnds)

local jokeStarts = {
    "Important observation: ", "I have reached a scientific conclusion: ", "Completely serious thought: ", "I blame game design for this, but ",
    "Do not quote me on this, but ", "After extensive research, ", "I have a theory: ", "You know what nobody tells adventurers? ",
    "This is probably obvious, but ", "I would like the record to show that ",
}
local jokeEnds = {
    "every cave has at least one branch that exists purely to waste your time.",
    "the chance of needing an item increases immediately after you vendor it.",
    "quest objectives become invisible the moment you actually start looking for them.",
    "the mob you need is always on the other side of the hill you just climbed.",
    "inventory space is a temporary illusion.",
    "the final ten percent of a level takes seventeen emotional years.",
    "every shortcut contains either a cliff or unnecessary combat.",
    "repair bills are just a subscription fee for confidence.",
    "rare mobs can sense when you are facing the wrong direction.",
    "the fastest player in a dungeon is usually one doorway away from needing to wait for everyone else.",
    "there is no bag large enough to defeat hoarding.",
    "a player saying 'one last quest' has already lied to themselves.",
    "the more expensive an item looks, the less likely it is to match your outfit.",
    "flight paths are where productivity goes to take a nap.",
    "the Auction House is just competitive spreadsheet roleplay with prettier icons.",
    "half of adventuring is solving problems created by carrying too many solutions.",
    "NPCs have mastered the art of needing help while standing completely still.",
    "the safest pull is always the one you considered boring and skipped.",
    "the moment you say 'this is easy' the game starts filling out paperwork.",
    "your best loot always drops five minutes after you decided nothing useful drops here.",
    "every dungeon has one hallway designed by somebody who hated maps.",
    "the first rule of farming is that the thing you want can smell impatience.",
    "a full quest log is basically a calendar with violence.",
    "if you cannot find the quest item, stand exactly where you already looked and rotate the camera once.",
    "there is always one consumable too valuable to use and too useless to sell.",
    "we would save a lot of time if villains simply mailed us their loot.",
    "bosses could solve many conflicts by skipping directly to the chest phase.",
    "the universe rewards careful planning with a patrol walking into your pull.",
    "the exact moment you relax is when another pack decides to participate.",
    "your character has survived gods, monsters, and yet still fears a slightly inconvenient ledge.",
    "one day quest givers will learn to bundle errands efficiently. Today is not that day.",
    "the amount of confidence in a pull is inversely related to how many enemies are hiding behind the camera.",
    "every player has at least one button they absolutely should use more often.",
    "the correct number of mounts is apparently always one more than you currently own.",
    "nothing makes an item feel valuable like putting it in the bank for six months and forgetting it exists.",
    "there is no such thing as a quick trip to town once the bank opens.",
    "the game knows when you said you were logging off soon.",
    "the most dangerous enemy in Azeroth is confidence immediately after a clean pull.",
    "loot luck is strongest when you have already emotionally given up.",
    "somewhere there is an NPC whose entire career is waiting for you to return with twelve identical objects.",
}
cross("megajoke", jokeStarts, jokeEnds)

FC:RefreshVocabularyStats()

add("personalreflection", {
    "%s: level %d %s in %s. Not a bad little snapshot of the day.",
    "%s, level %d on the %s, somewhere around %s. I do keep notes.",
    "%s, I know enough about this level %d %s in %s to recognize when you're settling into a rhythm.",
    "%s, your level %d %s is starting to feel at home in %s.",
    "%s, level %d %s in %s. Very heroic. Very administrative.",
    "%s, I remember when this level %d %s felt new. Current stop: %s.",
    "%s, this level %d %s has become familiar enough that %s feels normal now.",
    "%s, if this level %d %s develops another weird habit in %s, I am absolutely writing it down.",
    "%s, one benefit of following a level %d %s through %s is learning your patterns before you notice them.",
    "%s, the file currently says level %d %s, %s. You are not escaping the archive.",
    "%s, the numbers say level %d %s in %s. I mostly measure progress by how confidently you run into things now.",
    "%s, I am beginning to recognize how you play this level %d %s in %s before you make the decision.",
    "%s, every character gets a personality eventually. This level %d %s in %s definitely has one now.",
    "%s, your level %d %s has made %s feel familiar enough that I notice when the pace changes.",
    "%s, level %d %s in %s. That is enough shared history for me to have opinions.",
    "%s, this level %d %s in %s is getting comfortable. That is usually when you start getting ambitious.",
    "%s, I am keeping track: level %d, %s, %s. The archive is alive and judgmental.",
    "%s, your level %d %s has spent enough time in %s that I have officially developed expectations.",
    "%s, level %d %s, currently in %s. Somehow the confidence remains consistent across every character.",
    "%s, I know this level %d %s in %s well enough now to tell when you're about to get distracted.",
})
FC:RefreshVocabularyStats()
