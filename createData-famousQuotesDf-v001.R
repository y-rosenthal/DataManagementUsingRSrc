# We will use the "tribble" function that is part of the "tibble" package
# to create the data. That makes the code much easier to read then the 
# way you would normally create a dataframe (or tibble) in R.
#
# We will convert the data to a regular data.frame below so that you 
# don't need to understand tibbles to use this code.

library(tibble)

famousQuotesTbl <- tribble(
  ~Year,     ~Speaker,                                  ~Quote,
  -47,     "Julius Caesar",                          "I came, I saw, I conquered",
  -399,     "Socrates",                               "I know that I know nothing",
  -399,     "Socrates",                               "The unexamined life is not worth living",
  1597,     "Francis Bacon",                          "Knowledge is power",
  1603,     "William Shakespeare",                    "To be or not to be, that is the question",
  1637,     "René Descartes",                         "I think, therefore I am",
  1759,     "Voltaire",                               "I disapprove of what you say, but I will defend to the death your right to say it",
  1775,     "Patrick Henry",                          "Give me liberty, or give me death",
  1789,     "Marie Antoinette",                       "Let them eat cake",
  1843,     "Karl Marx",                              "Religion is the opium of the people",
  1848,     "Karl Marx",                              "Workers of the world, unite!",
  1858,     "Abraham Lincoln",                        "A house divided against itself cannot stand",
  1863,     "Abraham Lincoln",                        "Government of the people, by the people, for the people",
  1887,     "Lord Acton",                             "Power tends to corrupt, and absolute power corrupts absolutely",
  1901,     "Theodore Roosevelt",                     "Speak softly and carry a big stick",
  1929,     "Sherlock Holmes (Arthur Conan Doyle)",   "Elementary, my dear Watson",
  1929,     "Albert Einstein",                        "Imagination is more important than knowledge",
  1933,     "Franklin D. Roosevelt",                  "The only thing we have to fear is fear itself",
  1940,     "Winston Churchill",                      "We shall fight on the beaches",
  1940,     "Eleanor Roosevelt",                      "The future belongs to those who believe in the beauty of their dreams",
  1941,     "Winston Churchill",                      "Never, never, never give up",
  1942,     "Douglas MacArthur",                      "I shall return",
  1945,     "Harry S. Truman",                        "The buck stops here",
  1947,     "Mahatma Gandhi",                         "Be the change you wish to see in the world",
  1949,     "George Orwell",                          "War is peace. Freedom is slavery. Ignorance is strength",
  1951,     "Albert Camus",                           "The only way to deal with an unfree world is to become so absolutely free that your very existence is an act of rebellion",
  1961,     "John F. Kennedy",                        "Ask not what your country can do for you, ask what you can do for your country",
  1963,     "Martin Luther King Jr.",                 "I have a dream",
  1964,     "Muhammad Ali",                           "Float like a butterfly, sting like a bee",
  1964,     "Marshall McLuhan",                       "The medium is the message",
  1968,     "Martin Luther King Jr.",                 "I've been to the mountaintop",
  1969,     "Neil Armstrong",                         "That's one small step for man, one giant leap for mankind",
  1970,     "Irina Dunn",                             "A woman needs a man like a fish needs a bicycle",
  1980,     "John Lennon",                            "Life is what happens while you're busy making other plans",
  1980,     "Margaret Thatcher",                      "There is no alternative",
  1987,     "Ronald Reagan",                          "Mr. Gorbachev, tear down this wall",
  1988,     "George H. W. Bush",                      "Read my lips: no new taxes",
  2008,     "Barack Obama",                           "Yes we can"
)

# Convert to a regular data.frame
famousQuotesDf = as.data.frame(famousQuotesTbl)
