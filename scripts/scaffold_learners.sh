#!/usr/bin/env bash
set -euo pipefail

# List of attendees by full name; filenames are slugified versions
ATTENDEES=$(cat <<'PYLIST'
[
  "Ruby Krasnow",
  "Sylwia Zieba",
  "Sara Emery",
  "Shelley McMullen",
  "Jane Wolken",
  "Trevor Carter",
  "Kusum Naithani",
  "Annie Meeder",
  "Jack Shaw",
  "Maricela Abarca",
  "Zechariah Meunier",
  "Sam Pottinger",
  "Raelene Crandall",
  "Daniel Howard",
  "Kristin Davis",
  "Naupaka Zimmerman",
  "Youmi Oh",
  "Stefan Tangen",
  "Meagan Oldfather",
  "Wynne Moss",
  "Brian Miller",
  "Thilina Surasinghe",
  "Sierra Hicks",
  "Courtney King",
  "Eve Beaury",
  "Darryl Reano",
  "Wai Allen",
  "Maximilian Stiefel",
  "Sonita Singh",
  "Alicia Swimmer",
  "Israel Borokini",
  "Paula Antoine",
  "Philimon Two Eagle",
  "Alyssa Gleichsner",
  "Samantha Toledo",
  "Sarah Cuprewich",
  "Robert Newman",
  "Dana Gehring",
  "Daryl Jones III",
  "Jessica Weidenfeld",
  "Bob Rabin",
  "Helen Jiang",
  "Douglas Mbura",
  "Cullen Molitor",
  "Jacob Mensah",
  "Juan Maestre",
  "Maria Paula Rodriguez Parada",
  "Samuel Reed",
  "Syed Zeeshan Haider Kazmi",
  "Jennifer Fill",
  "Joan Dudney",
  "Terri Honani",
  "Di Yang",
  "Nevyn Neal",
  "Maya Zomer",
  "Rosny Jean",
  "Adeyinka Olusanya",
  "Lisa Sinclair",
  "Abdulganiyu Jimoh",
  "Charles Jason Tinant",
  "Cassandra (Beth) Koontz Scaffidi",
  "Christianah Adegboyega",
  "Manish Sarkar",
  "Aruni Kadawatha",
  "Sharif Islam",
  "John Mensah",
  "FNU AKSHAMA",
  "Nilima Islam Luba",
  "Julie Peeling",
  "Evan Fiorenza",
  "Durga Pravallika Kuchipudi",
  "Ana M Tarano",
  "Moriah Young",
  "Ashley Babcock",
  "Foster Sawyer",
  "Barth Robinson",
  "Trisha Spanbauer",
  "Jen Martel",
  "Rachel Mador-House",
  "Patrick Freeland",
  "Kate Thibault",
  "Carl Boettiger",
  "Brian Yandell",
  "Tyler McIntosh",
  "Lilly Jones",
  "Nayani Ilangakoon",
  "Lise St. Denis",
  "Katherine Siegel",
  "Nicole Hemming-Schroeder",
  "Matt Bitters",
  "Nate Hofford",
  "Danyan Leng",
  "Esther Rolf",
  "Lexi Wilkes",
  "Luca Anna Palasti",
  "Esmee Mulder",
  "Robert Ramos",
  "Min Gon Chung",
  "Cassie Buhler",
  "Katya Jay",
  "Kai Kopecky",
  "Keiko Nomura",
  "Kayleigh Ward",
  "Cibele Amaral",
  "James Sanovia",
  "Rachel Lieber",
  "Carrie Volpe",
  "Casey Jenson",
  "Alison Post",
  "Jennifer Balch",
  "Chelsea Nagy",
  "Ty Tuff",
  "Susan Sullivan",
  "John Parker",
  "Tyson Swetnam",
  "James Rattling Leaf",
  "Nate Quarderer",
  "Anne Gold",
  "Megan Littrell",
  "Emily Ward",
  "Virginia Iglesias",
  "Aashish Mukund",
  "Abby McConnell",
  "Hannah Love",
  "Ellen Fisher",
  "Brittany Bangerter",
  "Ellie",
  "Holly",
  "Emily Nagamoto- Katherine's grad student",
  "Spare 1",
  "Spare 2",
  "Spare 3",
  "Spare 4",
  "Spare 5"
]
PYLIST
)

echo "Ensuring docs/learners directory exists"
mkdir -p docs/learners

index_file="docs/learners/index.md"
# Create index file header
cat <<'INDEX' > "$index_file"
# Participants Scratchpad

Select your name below to open your scratchpad.

INDEX

# Parse names and generate files
python3 - <<'PY' "$ATTENDEES" |
import ast, sys, re
names = ast.literal_eval(sys.argv[1])
def slugify(name):
    slug = re.sub(r'[^a-z0-9]+', '-', name.lower())
    return slug.strip('-')
for name in names:
    print(f"{name}|{slugify(name)}")
PY
while IFS='|' read -r full_name slug; do
    file="docs/learners/${slug}.md"
    if [[ -e "$file" ]]; then
        echo "Skipping existing $file"
    else
        cat <<'EOF' > "$file"
# Your Name Here

Welcome to the GitHub training workshop!  
Please edit this file with your own details.

---

## About Me
- **Name:** Your full name  
- **Affiliation:** Your institution or organization  
- **Email:** your@email.edu  

## Research Interests
Write 2–3 sentences about your research focus, or what you are excited to learn in this workshop.  

## Fun Fact
Share one fun fact about yourself!  

---

*Instructions:*  
- Replace all the placeholder text above with your own info.  
- Save your edits (`git commit`) and push (`git push`) to share with the group.  
EOF
        echo "Created $file"
    fi
    printf -- "- [%s](%s.md)\n" "$full_name" "$slug" >> "$index_file"

done

echo "Adding files to git"
git add docs/learners scripts/scaffold_learners.sh mkdocs.yml

echo "Committing"
git commit -m "Scaffold learner templates"

echo "Pushing"
git push origin HEAD

echo "Done"
