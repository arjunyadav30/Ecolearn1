-- Setup script for question_bank table

-- Create question_bank table
CREATE TABLE IF NOT EXISTS question_bank (
    id INT AUTO_INCREMENT PRIMARY KEY,
    category VARCHAR(100) NOT NULL,
    question_text TEXT NOT NULL,
    option_a VARCHAR(500) NOT NULL,
    option_b VARCHAR(500) NOT NULL,
    option_c VARCHAR(500) NOT NULL,
    option_d VARCHAR(500) NOT NULL,
    correct_option CHAR(1) NOT NULL,
    difficulty_level ENUM('easy', 'medium', 'hard') DEFAULT 'medium',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_question_bank_category (category),
    INDEX idx_question_bank_difficulty (difficulty_level)
);

-- Insert more diverse sample data
INSERT IGNORE INTO question_bank (category, question_text, option_a, option_b, option_c, option_d, correct_option, difficulty_level) VALUES 
-- Mathematics
('Mathematics', 'What is the value of π (pi) approximately?', '3.14', '2.71', '1.61', '4.67', 'a', 'easy'),
('Mathematics', 'What is the derivative of x^2?', '2x', 'x^2', 'x', '2x^2', 'a', 'medium'),
('Mathematics', 'What is the integral of 2x dx?', 'x^2 + C', '2x^2 + C', 'x + C', '2x + C', 'a', 'medium'),
('Mathematics', 'What is the Pythagorean theorem?', 'a^2 + b^2 = c^2', 'a^2 - b^2 = c^2', 'a^2 * b^2 = c^2', 'a^2 / b^2 = c^2', 'a', 'easy'),
('Mathematics', 'What is the formula for the area of a circle?', 'πr^2', '2πr', 'πd', '2πr^2', 'a', 'easy'),
('Mathematics', 'What is the value of sin(90°)?', '0', '1', '0.5', 'Undefined', 'b', 'medium'),
('Mathematics', 'What is the sum of angles in a triangle?', '90°', '180°', '270°', '360°', 'b', 'easy'),
('Mathematics', 'What is the quadratic formula?', 'x = (-b ± √(b^2-4ac)) / 2a', 'x = (b ± √(b^2-4ac)) / 2a', 'x = (-b ± √(b^2+4ac)) / 2a', 'x = (b ± √(b^2+4ac)) / 2a', 'a', 'hard'),
('Mathematics', 'What is the slope of a horizontal line?', '0', '1', 'Undefined', 'Infinity', 'a', 'easy'),
('Mathematics', 'What is the value of e (Euler\'s number) approximately?', '2.718', '3.141', '1.618', '4.669', 'a', 'hard'),

-- Science
('Science', 'What is the chemical symbol for water?', 'H2O', 'CO2', 'NaCl', 'O2', 'a', 'easy'),
('Science', 'What is the speed of light in vacuum?', '3 x 10^8 m/s', '3 x 10^6 m/s', '3 x 10^10 m/s', '3 x 10^5 m/s', 'a', 'hard'),
('Science', 'What is the powerhouse of the cell?', 'Nucleus', 'Mitochondria', 'Ribosome', 'Endoplasmic reticulum', 'b', 'easy'),
('Science', 'What is the atomic number of Carbon?', '6', '8', '12', '14', 'a', 'medium'),
('Science', 'What is the process by which plants make food?', 'Respiration', 'Digestion', 'Photosynthesis', 'Fermentation', 'c', 'easy'),
('Science', 'What is the unit of electric current?', 'Volt', 'Watt', 'Ampere', 'Ohm', 'c', 'easy'),
('Science', 'What is the chemical symbol for Gold?', 'Ag', 'Au', 'Fe', 'Cu', 'b', 'medium'),
('Science', 'What is the hardest natural substance on Earth?', 'Gold', 'Iron', 'Diamond', 'Platinum', 'c', 'medium'),
('Science', 'What is the largest planet in our solar system?', 'Saturn', 'Jupiter', 'Neptune', 'Uranus', 'b', 'easy'),
('Science', 'What is the study of mushrooms called?', 'Mycology', 'Entomology', 'Ornithology', 'Botany', 'a', 'hard'),

-- History
('History', 'In which year did World War II end?', '1945', '1939', '1950', '1947', 'a', 'easy'),
('History', 'Who was the first President of the United States?', 'Thomas Jefferson', 'George Washington', 'Abraham Lincoln', 'John Adams', 'b', 'easy'),
('History', 'In which year did the Titanic sink?', '1910', '1912', '1914', '1916', 'b', 'medium'),
('History', 'Who painted the Mona Lisa?', 'Vincent van Gogh', 'Pablo Picasso', 'Leonardo da Vinci', 'Michelangelo', 'c', 'easy'),
('History', 'Which ancient civilization built the pyramids?', 'Romans', 'Greeks', 'Egyptians', 'Mesopotamians', 'c', 'easy'),
('History', 'In which year did India gain independence?', '1945', '1947', '1949', '1950', 'b', 'medium'),
('History', 'Who was the first man to walk on the moon?', 'Buzz Aldrin', 'Neil Armstrong', 'Yuri Gagarin', 'John Glenn', 'b', 'easy'),
('History', 'Which empire was ruled by Julius Caesar?', 'Greek', 'Roman', 'Byzantine', 'Ottoman', 'b', 'easy'),
('History', 'In which year did the Berlin Wall fall?', '1987', '1988', '1989', '1990', 'c', 'medium'),
('History', 'Who wrote the Communist Manifesto?', 'Vladimir Lenin', 'Joseph Stalin', 'Karl Marx', 'Friedrich Engels', 'c', 'hard'),

-- Geography
('Geography', 'What is the capital of France?', 'London', 'Berlin', 'Paris', 'Rome', 'c', 'easy'),
('Geography', 'Which is the longest river in the world?', 'Amazon River', 'Nile River', 'Mississippi River', 'Yangtze River', 'b', 'medium'),
('Geography', 'What is the largest ocean on Earth?', 'Atlantic', 'Indian', 'Arctic', 'Pacific', 'd', 'easy'),
('Geography', 'Which country is known as the Land of the Rising Sun?', 'China', 'Japan', 'South Korea', 'Thailand', 'b', 'easy'),
('Geography', 'What is the smallest country in the world?', 'Monaco', 'Vatican City', 'San Marino', 'Liechtenstein', 'b', 'medium'),
('Geography', 'Which continent is the Sahara Desert located in?', 'Asia', 'Africa', 'Australia', 'South America', 'b', 'easy'),
('Geography', 'What is the capital of Australia?', 'Sydney', 'Melbourne', 'Canberra', 'Perth', 'c', 'medium'),
('Geography', 'Which mountain range separates Europe and Asia?', 'Andes', 'Himalayas', 'Rockies', 'Ural', 'd', 'hard'),
('Geography', 'What is the largest desert in the world?', 'Sahara', 'Gobi', 'Arabian', 'Antarctic', 'd', 'medium'),
('Geography', 'Which river flows through London?', 'Seine', 'Thames', 'Danube', 'Rhine', 'b', 'easy'),

-- Literature
('Literature', 'Who wrote "Romeo and Juliet"?', 'Charles Dickens', 'William Shakespeare', 'Mark Twain', 'Jane Austen', 'b', 'easy'),
('Literature', 'What is the pen name of Samuel Clemens?', 'Mark Twain', 'George Eliot', 'Lewis Carroll', 'Oscar Wilde', 'a', 'medium'),
('Literature', 'Who wrote "To Kill a Mockingbird"?', 'Harper Lee', 'Ernest Hemingway', 'F. Scott Fitzgerald', 'John Steinbeck', 'a', 'medium'),
('Literature', 'Which novel features the character Holden Caulfield?', '1984', 'Brave New World', 'The Catcher in the Rye', 'Lord of the Flies', 'c', 'hard'),
('Literature', 'Who wrote "Pride and Prejudice"?', 'Charlotte Brontë', 'Emily Brontë', 'Jane Austen', 'George Eliot', 'c', 'easy'),
('Literature', 'What is the first book in the Harry Potter series?', 'Chamber of Secrets', 'Prisoner of Azkaban', 'Goblet of Fire', 'Philosopher\'s Stone', 'd', 'easy'),
('Literature', 'Who wrote "The Great Gatsby"?', 'Ernest Hemingway', 'F. Scott Fitzgerald', 'John Steinbeck', 'Mark Twain', 'b', 'medium'),
('Literature', 'Which Shakespeare play features the character Lady Macbeth?', 'Hamlet', 'Othello', 'King Lear', 'Macbeth', 'd', 'medium'),
('Literature', 'Who wrote "1984"?', 'Aldous Huxley', 'Ray Bradbury', 'George Orwell', 'Kurt Vonnegut', 'c', 'easy'),
('Literature', 'What is the sequel to "The Lord of the Rings"?', 'The Hobbit', 'The Silmarillion', 'The Two Towers', 'There is no sequel', 'd', 'hard'),

-- Computer Science
('Computer Science', 'What does CPU stand for?', 'Central Processing Unit', 'Computer Processing Unit', 'Central Processor Unit', 'Computer Processor Unit', 'a', 'easy'),
('Computer Science', 'Which programming language is known as the "language of the web"?', 'Python', 'Java', 'JavaScript', 'C++', 'c', 'easy'),
('Computer Science', 'What is the time complexity of binary search?', 'O(n)', 'O(log n)', 'O(n^2)', 'O(1)', 'b', 'hard'),
('Computer Science', 'What does HTML stand for?', 'Hyper Text Markup Language', 'High Tech Modern Language', 'Home Tool Markup Language', 'Hyperlink and Text Markup Language', 'a', 'easy'),
('Computer Science', 'Which company developed the Java programming language?', 'Microsoft', 'Apple', 'Google', 'Sun Microsystems', 'd', 'medium'),
('Computer Science', 'What is the file extension for a Python file?', '.py', '.java', '.js', '.cpp', 'a', 'easy'),
('Computer Science', 'What does RAM stand for?', 'Random Access Memory', 'Read Access Memory', 'Rapid Access Memory', 'Remote Access Memory', 'a', 'easy'),
('Computer Science', 'Which of these is not a programming paradigm?', 'Object-oriented', 'Functional', 'Relational', 'Procedural', 'c', 'medium'),
('Computer Science', 'What is the primary purpose of an operating system?', 'Run applications', 'Manage hardware resources', 'Connect to the internet', 'Store data', 'b', 'easy'),
('Computer Science', 'What does SQL stand for?', 'Structured Query Language', 'Standard Query Language', 'Simple Query Language', 'System Query Language', 'a', 'easy'),

-- Physics
('Physics', 'What is the unit of force in SI system?', 'Joule', 'Watt', 'Newton', 'Pascal', 'c', 'easy'),
('Physics', 'What is the formula for kinetic energy?', 'KE = mv', 'KE = mv^2', 'KE = (1/2)mv^2', 'KE = (1/2)mv', 'c', 'medium'),
('Physics', 'What is the speed of sound in air approximately?', '343 m/s', '3 x 10^8 m/s', '9.8 m/s', '1500 m/s', 'a', 'medium'),
('Physics', 'Which law states that for every action, there is an equal and opposite reaction?', 'Newton\'s First Law', 'Newton\'s Second Law', 'Newton\'s Third Law', 'Law of Conservation of Energy', 'c', 'easy'),
('Physics', 'What is the unit of electric charge?', 'Volt', 'Ampere', 'Coulomb', 'Ohm', 'c', 'medium'),
('Physics', 'What is the phenomenon where light bends when passing through different media?', 'Reflection', 'Refraction', 'Diffraction', 'Interference', 'b', 'easy'),
('Physics', 'What is the SI unit of temperature?', 'Celsius', 'Fahrenheit', 'Kelvin', 'Rankine', 'c', 'medium'),
('Physics', 'Which particle is responsible for electric current in metals?', 'Proton', 'Neutron', 'Electron', 'Photon', 'c', 'easy'),
('Physics', 'What is the acceleration due to gravity on Earth?', '9.8 m/s²', '8.9 m/s²', '10.2 m/s²', '7.6 m/s²', 'a', 'easy'),
('Physics', 'What is the unit of power?', 'Joule', 'Watt', 'Volt', 'Ampere', 'b', 'easy'),

-- Chemistry
('Chemistry', 'What is the pH of pure water?', '0', '7', '14', '10', 'b', 'easy'),
('Chemistry', 'Which element has the chemical symbol "Au"?', 'Silver', 'Aluminum', 'Gold', 'Argon', 'c', 'medium'),
('Chemistry', 'What is the chemical formula for table salt?', 'NaCl', 'KCl', 'CaCl2', 'MgCl2', 'a', 'easy'),
('Chemistry', 'Which gas is most abundant in Earth\'s atmosphere?', 'Oxygen', 'Carbon Dioxide', 'Nitrogen', 'Argon', 'c', 'easy'),
('Chemistry', 'What is the process of converting a liquid to a gas called?', 'Condensation', 'Freezing', 'Evaporation', 'Sublimation', 'c', 'easy'),
('Chemistry', 'Which element has the atomic number 1?', 'Helium', 'Hydrogen', 'Lithium', 'Beryllium', 'b', 'easy'),
('Chemistry', 'What is the chemical symbol for Iron?', 'Ir', 'In', 'Fe', 'Fi', 'c', 'easy'),
('Chemistry', 'Which acid is found in citrus fruits?', 'Hydrochloric acid', 'Sulfuric acid', 'Nitric acid', 'Citric acid', 'd', 'medium'),
('Chemistry', 'What is the term for a substance that speeds up a chemical reaction?', 'Reactant', 'Product', 'Catalyst', 'Inhibitor', 'c', 'medium'),
('Chemistry', 'Which of the following is a noble gas?', 'Oxygen', 'Nitrogen', 'Helium', 'Carbon', 'c', 'easy'),

-- Biology
('Biology', 'How many bones are there in an adult human body?', '206', '300', '150', '250', 'a', 'medium'),
('Biology', 'What is the largest organ in the human body?', 'Liver', 'Brain', 'Skin', 'Heart', 'c', 'easy'),
('Biology', 'Which blood cells are responsible for fighting infections?', 'Red blood cells', 'White blood cells', 'Platelets', 'Plasma', 'b', 'easy'),
('Biology', 'What is the basic unit of life?', 'Organ', 'Tissue', 'Cell', 'Organism', 'c', 'easy'),
('Biology', 'Which organ pumps blood throughout the body?', 'Lungs', 'Liver', 'Kidneys', 'Heart', 'd', 'easy'),
('Biology', 'What is the process by which plants convert sunlight into energy?', 'Respiration', 'Digestion', 'Photosynthesis', 'Fermentation', 'c', 'easy'),
('Biology', 'Which part of the brain controls balance and coordination?', 'Cerebrum', 'Cerebellum', 'Brainstem', 'Hypothalamus', 'b', 'hard'),
('Biology', 'What are the building blocks of proteins?', 'Carbohydrates', 'Lipids', 'Nucleotides', 'Amino acids', 'd', 'medium'),
('Biology', 'Which vitamin is produced when skin is exposed to sunlight?', 'Vitamin A', 'Vitamin B', 'Vitamin C', 'Vitamin D', 'd', 'medium'),
('Biology', 'What is the function of red blood cells?', 'Fight infection', 'Clot blood', 'Carry oxygen', 'Store nutrients', 'c', 'easy'),

-- Economics
('Economics', 'What does GDP stand for?', 'Gross Domestic Product', 'Gross Domestic Profit', 'Global Domestic Product', 'General Domestic Product', 'a', 'easy'),
('Economics', 'What is inflation?', 'Decrease in price level', 'Increase in price level', 'Stable price level', 'Fluctuating price level', 'b', 'easy'),
('Economics', 'What is the term for the total value of goods and services produced in a country?', 'GNP', 'GDP', 'CPI', 'PPI', 'b', 'easy'),
('Economics', 'Which institution is responsible for monetary policy in the US?', 'Treasury Department', 'Federal Reserve', 'SEC', 'FDIC', 'b', 'medium'),
('Economics', 'What is the term for a market with only one seller?', 'Oligopoly', 'Monopoly', 'Monopolistic Competition', 'Perfect Competition', 'b', 'medium'),
('Economics', 'What is the opportunity cost?', 'The cost of the next best alternative', 'The total cost of production', 'The cost of raw materials', 'The cost of labor', 'a', 'hard'),
('Economics', 'What is a recession?', 'Period of economic growth', 'Period of economic decline', 'Period of stable economy', 'Period of high inflation', 'b', 'easy'),
('Economics', 'What is the law of demand?', 'As price increases, quantity demanded increases', 'As price decreases, quantity demanded decreases', 'As price increases, quantity demanded decreases', 'Price and quantity demanded are unrelated', 'c', 'medium'),
('Economics', 'What is a tariff?', 'Tax on income', 'Tax on property', 'Tax on imports', 'Tax on sales', 'c', 'easy'),
('Economics', 'What is the unemployment rate?', 'Percentage of working population', 'Percentage of non-working population', 'Percentage of labor force that is unemployed', 'Percentage of population that wants to work', 'c', 'medium'),

-- Art
('Art', 'Who painted the Mona Lisa?', 'Vincent van Gogh', 'Pablo Picasso', 'Leonardo da Vinci', 'Michelangelo', 'c', 'easy'),
('Art', 'Which artist is known for cutting off his own ear?', 'Pablo Picasso', 'Claude Monet', 'Vincent van Gogh', 'Salvador Dalí', 'c', 'medium'),
('Art', 'What is the art of beautiful handwriting called?', 'Typography', 'Calligraphy', 'Graphology', 'Penmanship', 'b', 'medium'),
('Art', 'Which artistic movement was pioneered by Pablo Picasso?', 'Impressionism', 'Cubism', 'Surrealism', 'Expressionism', 'b', 'medium'),
('Art', 'Who sculpted David?', 'Donatello', 'Bernini', 'Michelangelo', 'Rodin', 'c', 'easy'),
('Art', 'What is the primary color that cannot be created by mixing other colors?', 'Green', 'Purple', 'Orange', 'Blue', 'd', 'easy'),
('Art', 'Which museum is famous for housing the Mona Lisa?', 'Metropolitan Museum of Art', 'Tate Modern', 'Louvre Museum', 'Guggenheim Museum', 'c', 'medium'),
('Art', 'What is the technique of applying paint to wet plaster called?', 'Oil painting', 'Watercolor', 'Fresco', 'Acrylic painting', 'c', 'hard'),
('Art', 'Who painted The Starry Night?', 'Claude Monet', 'Vincent van Gogh', 'Pablo Picasso', 'Salvador Dalí', 'b', 'easy'),
('Art', 'What is the study of the meaning of artworks called?', 'Aesthetics', 'Art History', 'Iconography', 'Criticism', 'c', 'hard'),

-- Music
('Music', 'How many notes are there in a musical scale?', '7', '8', '12', '5', 'a', 'easy'),
('Music', 'What is the highest male singing voice?', 'Bass', 'Baritone', 'Tenor', 'Countertenor', 'c', 'medium'),
('Music', 'Which instrument has 88 keys?', 'Piano', 'Organ', 'Harpsichord', 'Synthesizer', 'a', 'easy'),
('Music', 'What is the tempo marking for a slow piece of music?', 'Allegro', 'Pianissimo', 'Adagio', 'Forte', 'c', 'medium'),
('Music', 'Which composer wrote the "Moonlight Sonata"?', 'Johann Sebastian Bach', 'Wolfgang Amadeus Mozart', 'Ludwig van Beethoven', 'Frédéric Chopin', 'c', 'medium'),
('Music', 'What is the term for a group of musicians playing together?', 'Orchestra', 'Band', 'Ensemble', 'All of the above', 'd', 'easy'),
('Music', 'Which of these is a percussion instrument?', 'Violin', 'Flute', 'Trumpet', 'Drums', 'd', 'easy'),
('Music', 'What does "forte" mean in musical terms?', 'Softly', 'Loudly', 'Slowly', 'Quickly', 'b', 'easy'),
('Music', 'Which composer is known as the "Father of the Symphony"?', 'Johann Sebastian Bach', 'Wolfgang Amadeus Mozart', 'Ludwig van Beethoven', 'Franz Joseph Haydn', 'd', 'hard'),
('Music', 'What is the interval between two notes that are 12 semitones apart?', 'Octave', 'Fifth', 'Fourth', 'Third', 'a', 'medium'),

-- Environmental Science
('Environmental Science', 'What is the primary greenhouse gas?', 'Oxygen', 'Nitrogen', 'Carbon Dioxide', 'Methane', 'c', 'easy'),
('Environmental Science', 'What is the term for the variety of life in a particular habitat?', 'Ecosystem', 'Biodiversity', 'Biome', 'Population', 'b', 'easy'),
('Environmental Science', 'Which layer of the atmosphere contains the ozone layer?', 'Troposphere', 'Stratosphere', 'Mesosphere', 'Thermosphere', 'b', 'medium'),
('Environmental Science', 'What is the process of converting waste materials into reusable objects?', 'Incineration', 'Landfilling', 'Recycling', 'Composting', 'c', 'easy'),
('Environmental Science', 'What is the main cause of acid rain?', 'Deforestation', 'Overfishing', 'Air pollution', 'Soil erosion', 'c', 'easy'),
('Environmental Science', 'Which renewable energy source uses the sun\'s energy?', 'Wind power', 'Hydroelectric power', 'Solar power', 'Geothermal energy', 'c', 'easy'),
('Environmental Science', 'What is the term for the gradual increase in Earth\'s temperature?', 'Global warming', 'Climate change', 'Ozone depletion', 'Acid rain', 'a', 'easy'),
('Environmental Science', 'Which gas do plants absorb during photosynthesis?', 'Oxygen', 'Nitrogen', 'Carbon Dioxide', 'Methane', 'c', 'easy'),
('Environmental Science', 'What is the largest source of renewable energy?', 'Wind', 'Solar', 'Hydroelectric', 'Geothermal', 'c', 'medium'),
('Environmental Science', 'What is the term for species that are at risk of extinction?', 'Endangered', 'Threatened', 'Vulnerable', 'Extinct', 'a', 'easy'),

-- Technology
('Technology', 'What does "www" stand for in a website address?', 'World Wide Web', 'World Web Wide', 'Web World Wide', 'Wide World Web', 'a', 'easy'),
('Technology', 'Which company developed the iPhone?', 'Google', 'Microsoft', 'Apple', 'Samsung', 'c', 'easy'),
('Technology', 'What is the brain of a computer called?', 'RAM', 'Hard Drive', 'CPU', 'Motherboard', 'c', 'easy'),
('Technology', 'Which of these is a social media platform?', 'Microsoft Word', 'Excel', 'Facebook', 'PowerPoint', 'c', 'easy'),
('Technology', 'What does "USB" stand for?', 'Universal Serial Bus', 'United Serial Bus', 'Universal System Bus', 'United System Bus', 'a', 'medium'),
('Technology', 'Which programming language is often used for data science?', 'HTML', 'CSS', 'Python', 'JavaScript', 'c', 'easy'),
('Technology', 'What is the term for a malicious software that spreads copies of itself?', 'Virus', 'Trojan', 'Worm', 'Spyware', 'c', 'medium'),
('Technology', 'Which cloud computing service is provided by Amazon?', 'Google Drive', 'Dropbox', 'OneDrive', 'AWS', 'd', 'medium'),
('Technology', 'What is the resolution of a 4K display?', '1920x1080', '2560x1440', '3840x2160', '7680x4320', 'c', 'hard'),
('Technology', 'Which protocol is used to send emails?', 'HTTP', 'FTP', 'SMTP', 'TCP', 'c', 'medium');