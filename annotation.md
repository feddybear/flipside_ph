## Tagging and Spelling Rules

In general, do not agonize over decisions.  If the event is not covered here, please ask on [Project Flipside's Slack workspace](https://projectflipside.slack.com/archives/C01T7U18J9M).

You can use colon to separate tag name with spoken words.  When enclosing tags with <>, or (()) please ensure that there are no spaces in between the opening and closing symbols.  Use _ if spaces are needed in between.

### Speech Events

#### Unintelligible

If you cannot understand what is said, replace the word with (())

#### Fillers / Hesitancies

Fillers are sounds or words that if omitted from the transcript, would not change what the speaker is trying to convey.  You can use &lt;fill:>, &lt;filler:>, or &lt;hes:\>.  Try to re-read your transcripts without the enclosed tag to test your decision.

1. Thinking words\
   e.g. &lt;filler:ah>, &lt;filler:mm>
2. Non-lexical filler\
   e.g. &lt;filler:eh>
3. Fragments/repeats due to false starts.  For fragments, hyphenate the cut-off point.\
   e.g. &lt;filler:ma-> magandang &lt;filler:uma-> tanghali\
   e.g. &lt;filler:one> one million pesos

#### Mispronunciations / Incomplete

If the speaker mispronounces the word or the word is cut-off NOT because of the speaker.  Fragments should be hyphenated at cut-off points.  There are two cases:

1. If the correct word can be supplied, use &lt;miss:wrong:right>
2. If the correct word cannot be supplied, use ((what_was_heard))

Examples:
1. The speaker says "tini**g**nan\"\
   e.g. &lt;miss:tinignan:tiningnan> mo ba?
2. Example where the incomplete word is obvious\
   e.g. Pula, puti, &lt;miss:as-:asul>

#### Foreign Words
The &lt;foreign> tag is used when the speaker says a word or string of words from another language that would not be widely accepted or understood as part of the native language. This utterance is NOT
transcribed and the <foreign> tag is inserted instead.

Individual loan words that are spoken and commonly used as part of the native language are transcribed with the accepted loan word spelling. For example, words such as “kimono”, “croissant”, or “falafel” would be considered commonly accepted loan words in the language. Such words are written using the same character set as the native language.

#### Overlaps / Crosstalk / Crowds

When two or more people talk over the same region, place the words inside a <overlap:transcript> tag to complete the thought of the utterance you are writing.  The word content can be left out if they're only noise.


### Non-speech Events

Use the tags below only if the event is clearly distinguishable.  If the event occurs over a span of one or more words, the tag should indicate where it starts, just before the first word it affects.

Categories:
- &lt;breath> for loud breathing
- &lt;burp>
- &lt;cough>
- &lt;laugh>
- &lt;music>
- &lt;pause> for pause in talking
- &lt;ring> for phone rings
- &lt;sneeze>
- &lt;sniff>
- &lt;swoosh> for transitional sound effects
- &lt;throat> for clearing throat, like ehem
- &lt;whisper>

### Spelling

Proper nouns should retain their original spelling.

#### Titles and abbreviations

Titles are transcribed as word: "Dr." must be written as "Doctor"

Exceptions are when the abbreviated form are actually pronounced that way.  If someone says /ink/ for Incorporated, write Inc instead of Incorporated.

#### Punctuation

Do not use punctuations unless they are essential for the word.  Always try to write contractions completely.

#### Acronyms

Acronyms are transcribed as words if spoken as words, and as letters if spoken as letters. When transcribing sequences of letters an underscore is inserted between each letter. For example: PAG-ASA;
A_B_S-C_B_N

#### Numbers

Never write numerals.  Always transcribe in full words.\
16 -> sixteen\
1,024 -> one thousand twenty four

#### Phonetic spelling

Use the / / tag when the letter is pronounced/lipped instead of saying the letter name.

#### Filipino-specific

1. Choose between Balarila system and original spelling depending on the way the word fits into the utterance, usually dependent on the pronunciation.\
e.g. Hinuli ang suspek (vs suspect) ng pulis (vs police)\
     Inisnab (vs ini-snob) ang gimik (vs gimmick) ng mga istambay (vs standby)
2. When a Filipino prefix is attached to a borrowed word, separate the prefix with a hyphen:\
e.g. nag-shopping, naka-long-sleeves, pa-try
3. When a borrowed word undergoes partial reduplication, retain the spelling of the duplicated part from the root word, separated with hyphen:\
e.g. mag-sho-shopping, age-agenda, i-fo-forward
4. Infixations with "in" and "um".  In certain cases, spellings of the root word will change (from c to k in the example below).\
e.g. finorward, gumraduate, **k**inompute\
fino-forward, guma-graduate, **k**ino-**c**ompute
