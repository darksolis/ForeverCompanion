local FC = _G.ForeverCompanion

local TRIVIA = {
    { "What is the largest planet in our solar system?", "Jupiter." },
    { "Which planet is known for its prominent ring system?", "Saturn." },
    { "What is the closest star to Earth?", "The Sun." },
    { "What galaxy contains our solar system?", "The Milky Way." },
    { "What is the name of Earth's natural satellite?", "The Moon." },
    { "Which planet is famous for Olympus Mons?", "Mars." },
    { "Which planet rotates on its side compared with the others?", "Uranus." },
    { "What force keeps planets in orbit around the Sun?", "Gravity." },
    { "What is a light-year a measure of?", "Distance." },
    { "What type of star is the Sun?", "A G-type main-sequence star." },
    { "What gas is most abundant in Earth's atmosphere?", "Nitrogen." },
    { "What gas do plants take in during photosynthesis?", "Carbon dioxide." },
    { "What gas do humans primarily need from the air for cellular respiration?", "Oxygen." },
    { "What is H2O commonly called?", "Water." },
    { "What is the chemical symbol for gold?", "Au." },
    { "What is the chemical symbol for iron?", "Fe." },
    { "What is the chemical symbol for sodium?", "Na." },
    { "What is the chemical symbol for potassium?", "K." },
    { "What is the chemical symbol for silver?", "Ag." },
    { "What element has atomic number 1?", "Hydrogen." },
    { "What element has atomic number 6?", "Carbon." },
    { "What element has atomic number 8?", "Oxygen." },
    { "What organ pumps blood through the human body?", "The heart." },
    { "What organ is primarily responsible for filtering blood and producing urine?", "The kidneys." },
    { "What organ performs many metabolic functions and produces bile?", "The liver." },
    { "What part of the nervous system includes the brain and spinal cord?", "The central nervous system." },
    { "What blood cells carry most oxygen in the blood?", "Red blood cells." },
    { "What molecule carries genetic information in most living organisms?", "DNA." },
    { "What process lets plants convert light energy into chemical energy?", "Photosynthesis." },
    { "What cell structure is often called the powerhouse of the cell?", "The mitochondrion." },
    { "What is the largest living animal known today?", "The blue whale." },
    { "What is the fastest land animal over short distances?", "The cheetah." },
    { "Which mammal is capable of sustained powered flight?", "The bat." },
    { "What animal is the largest member of the dolphin family?", "The orca, or killer whale." },
    { "What is a baby frog called after it hatches?", "A tadpole." },
    { "What do you call an animal that eats both plants and animals?", "An omnivore." },
    { "What do you call an animal that primarily eats plants?", "A herbivore." },
    { "What do you call an animal that primarily eats other animals?", "A carnivore." },
    { "Which bird is the largest living bird by height and mass?", "The ostrich." },
    { "Which living bird has the greatest wingspan on average?", "The wandering albatross." },
    { "What is the largest ocean on Earth?", "The Pacific Ocean." },
    { "What is the largest continent by land area?", "Asia." },
    { "What is the smallest continent by land area in the common seven-continent model?", "Australia." },
    { "What is the world's largest island that is not considered a continent?", "Greenland." },
    { "What is the deepest freshwater lake in the world?", "Lake Baikal." },
    { "Which mountain is the highest above mean sea level?", "Mount Everest." },
    { "What is the capital of Japan?", "Tokyo." },
    { "What is the capital of France?", "Paris." },
    { "What is the capital of Australia?", "Canberra." },
    { "What is the capital of Canada?", "Ottawa." },
    { "What is the capital of Brazil?", "Brasilia." },
    { "What is the capital of Egypt?", "Cairo." },
    { "What is the capital of Iceland?", "Reykjavik." },
    { "What is the capital of New Zealand?", "Wellington." },
    { "What is the capital of South Korea?", "Seoul." },
    { "What is the capital of Norway?", "Oslo." },
    { "Which ancient civilization built Machu Picchu?", "The Inca." },
    { "Which ancient civilization built the Parthenon?", "The ancient Greeks." },
    { "Which civilization built the city of Petra?", "The Nabataeans." },
    { "What writing material made from a plant was widely used in ancient Egypt?", "Papyrus." },
    { "Who is traditionally credited with writing the Iliad and the Odyssey?", "Homer." },
    { "Who wrote Hamlet?", "William Shakespeare." },
    { "Who wrote Pride and Prejudice?", "Jane Austen." },
    { "Who wrote A Christmas Carol?", "Charles Dickens." },
    { "Who wrote Frankenstein?", "Mary Shelley." },
    { "Who wrote The Adventures of Tom Sawyer?", "Mark Twain." },
    { "What language did ancient Romans use for much official writing?", "Latin." },
    { "What is a word with the opposite meaning of another word called?", "An antonym." },
    { "What is a word with a similar meaning to another word called?", "A synonym." },
    { "What is a word or phrase that reads the same forward and backward called?", "A palindrome." },
    { "What is the study of word origins called?", "Etymology." },
    { "What punctuation mark ends a direct question in English?", "A question mark." },
    { "How many sides does a hexagon have?", "Six." },
    { "How many sides does an octagon have?", "Eight." },
    { "What is the square root of 81?", "9." },
    { "What is 12 times 12?", "144." },
    { "What is the only even prime number?", "2." },
    { "What number is represented by the Roman numeral X?", "10." },
    { "What number is represented by the Roman numeral L?", "50." },
    { "What number is represented by the Roman numeral C?", "100." },
    { "What is the sum of the angles in a Euclidean triangle?", "180 degrees." },
    { "What branch of mathematics studies chance and uncertainty?", "Probability." },
    { "What is the mean of 2, 4, 6, and 8?", "5." },
    { "What is the binary representation of decimal 2?", "10." },
    { "How many bits are in a standard byte?", "Eight." },
    { "What does CPU stand for?", "Central Processing Unit." },
    { "What does RAM stand for?", "Random Access Memory." },
    { "What does URL stand for?", "Uniform Resource Locator." },
    { "What does HTTP stand for?", "Hypertext Transfer Protocol." },
    { "What does GPS stand for?", "Global Positioning System." },
    { "What does DNA stand for?", "Deoxyribonucleic acid." },
    { "What does RNA stand for?", "Ribonucleic acid." },
    { "What image format is known for lossless compression and transparency support?", "PNG." },
    { "What does an operating system primarily manage?", "Computer hardware resources and services for software." },
    { "What does a compiler generally do?", "Translate source code into another executable or lower-level form." },
    { "What does DNS help translate?", "Domain names into network addresses and related records." },
    { "Which protocol family underlies most internet communication?", "TCP/IP." },
    { "What is a backup meant to protect against?", "Data loss." },
    { "What is phishing?", "A fraudulent attempt to trick someone into revealing information or taking an unsafe action." },
    { "What is encryption used for?", "Transforming information so unauthorized parties cannot readily read it." },
    { "What instrument has 88 keys on a standard modern version?", "The piano." },
    { "How many strings does a standard violin have?", "Four." },
    { "What family of instruments includes the flute and clarinet?", "Woodwinds." },
    { "What family of instruments includes the trumpet and trombone?", "Brass." },
    { "What is the lowest common adult male singing range commonly called?", "Bass." },
    { "What is the highest common adult female singing range commonly called?", "Soprano." },
    { "In visual art, what are red, yellow, and blue traditionally called in the RYB model?", "Primary colors." },
    { "Who painted the Mona Lisa?", "Leonardo da Vinci." },
    { "Who painted The Starry Night?", "Vincent van Gogh." },
    { "What artistic technique uses small dots of color to build an image?", "Pointillism." },
    { "What cooking reaction creates many browned flavors when amino acids react with reducing sugars?", "The Maillard reaction." },
    { "What compound creates the burning sensation in chili peppers?", "Capsaicin." },
    { "What basic taste is strongly associated with glutamate?", "Umami." },
    { "What microorganism is commonly used to make bread rise?", "Yeast." },
    { "What grain is traditionally used to make risotto?", "Rice, commonly Arborio or another short-grain variety." },
    { "What is tofu primarily made from?", "Soybeans." },
    { "What spice comes from the dried stigmas of a crocus flower?", "Saffron." },
    { "What plant do vanilla beans come from?", "An orchid in the genus Vanilla." },
    { "What is the main ingredient in traditional hummus?", "Chickpeas." },
    { "What fermented dairy food is made using bacterial cultures?", "Yogurt." },
    { "What is the process of changing directly from a solid to a gas called?", "Sublimation." },
    { "What is the process of changing from a gas directly to a solid called?", "Deposition." },
    { "What is the freezing point of pure water at standard atmospheric pressure in Celsius?", "0 degrees Celsius." },
    { "What is the boiling point of pure water at standard atmospheric pressure in Celsius?", "100 degrees Celsius." },
    { "What unit is used to measure electric current?", "The ampere." },
    { "What unit is used to measure electrical resistance?", "The ohm." },
    { "What is the SI unit of force?", "The newton." },
    { "What is the SI unit of energy?", "The joule." },
    { "What is the SI unit of power?", "The watt." },
    { "What is the speed of light in vacuum approximately?", "About 300,000 kilometers per second." },
    { "What scientist formulated the laws of motion and universal gravitation?", "Isaac Newton." },
    { "Who developed the theory of general relativity?", "Albert Einstein." },
    { "Who is associated with the laws of planetary motion?", "Johannes Kepler." },
    { "Who pioneered work on radioactivity and won Nobel Prizes in two different sciences?", "Marie Curie." },
    { "Who developed a system for naming organisms with binomial nomenclature?", "Carl Linnaeus." },
    { "Who proposed evolution by natural selection alongside Alfred Russel Wallace?", "Charles Darwin." },
    { "What branch of science studies weather?", "Meteorology." },
    { "What branch of science studies earthquakes?", "Seismology." },
    { "What branch of science studies fungi?", "Mycology." },
    { "What branch of science studies birds?", "Ornithology." },
    { "What branch of science studies insects?", "Entomology." },
    { "What is a group of stars forming a recognized pattern called?", "A constellation." },
    { "What instrument measures atmospheric pressure?", "A barometer." },
    { "What instrument measures temperature?", "A thermometer." },
    { "What instrument measures wind speed?", "An anemometer." },
    { "What scale is commonly used to classify hurricane intensity in the Atlantic and eastern Pacific?", "The Saffir-Simpson Hurricane Wind Scale." },
    { "What kind of rock forms from cooled magma or lava?", "Igneous rock." },
    { "What kind of rock forms from compacted or cemented sediments?", "Sedimentary rock." },
    { "What kind of rock forms when existing rock is transformed by heat and pressure?", "Metamorphic rock." },
    { "What is molten rock beneath Earth's surface called?", "Magma." },
    { "What is molten rock at Earth's surface called?", "Lava." },
    { "What is the boundary between two tectonic plates called?", "A plate boundary." },
    { "What process turns liquid water into water vapor?", "Evaporation." },
    { "What process turns water vapor into liquid water?", "Condensation." },
    { "What is frozen precipitation made of ice crystals called?", "Snow." },
    { "What optical phenomenon separates white light into colors after refraction and reflection in water droplets?", "A rainbow." },
    { "In World of Warcraft, what faction includes Stormwind and Ironforge?", "The Alliance." },
    { "In World of Warcraft, what faction includes Orgrimmar and Thunder Bluff?", "The Horde." },
    { "What city is built inside a mountain in Dun Morogh?", "Ironforge." },
    { "What city lies beneath the ruins of Lordaeron in classic-era Warcraft?", "The Undercity." },
    { "What battleground is based on capture the flag?", "Warsong Gulch." },
    { "What battleground centers on controlling resource nodes?", "Arathi Basin." },
    { "What is the name of the tram connecting Stormwind and Ironforge?", "The Deeprun Tram." },
    { "What was Orgrimmar named in honor of?", "Orgrim Doomhammer." },
    { "What dragon once infiltrated Stormwind as Lady Katrana Prestor?", "Onyxia." },
    { "What low-level gnoll became one of WoW's most famous early enemies?", "Hogger." },
}

local OPENERS = {
    "Trivia time. ", "Quick question. ", "Thirty-second trivia: ", "Let's see what you know. ",
    "Vexa trivia: ", "No searching. ", "Tiny knowledge check: ", "One question, no pressure: ",
}

function FC:BuildTriviaBank()
    if self.triviaBank then return self.triviaBank end
    local bank = {}
    for _, pair in ipairs(TRIVIA) do
        for _, opener in ipairs(OPENERS) do
            bank[#bank + 1] = { question = opener .. pair[1], answer = pair[2] }
        end
    end
    self.triviaBank = bank
    return bank
end

function FC:StartTrivia(force)
    if not self.db or not self.db.enabled then return false end
    if self.state.pendingTrivia and not force then return false end
    local bank = self:BuildTriviaBank()
    if #bank == 0 then return false end
    local item = bank[math.random(1, #bank)]
    self.state.pendingTrivia = { question = item.question, answer = item.answer, answerAt = GetTime() + 30, askedAt = GetTime() }
    self:Say(item.question, "think", 30, true, { topic = "trivia", category = "learning", reason = "trivia question" })
    return true
end

function FC:AnswerTrivia(force)
    local pending = self.state.pendingTrivia
    if not pending then
        if force then self:Say("No trivia question is waiting. Ask me for one first.", "shrug", 100, true, { topic = "triviaanswer", category = "learning" }) end
        return false
    end
    if not force and GetTime() < (pending.answerAt or 0) then return false end
    if not force and (self.state.inCombat or self.state.contextMode == "combat") then return false end
    local answer = pending.answer
    self.state.pendingTrivia = nil
    self:QueueSay("Trivia answer: " .. tostring(answer), "playful", 25, 0, "triviaanswer", true, nil, { topic = "triviaanswer", category = "learning", reason = "30-second trivia answer" })
    return true
end

function FC:TriviaTick()
    if self.state.pendingTrivia and GetTime() >= (self.state.pendingTrivia.answerAt or math.huge) then self:AnswerTrivia(false) end
end

function FC:TellTrivia()
    return self:StartTrivia(true)
end
