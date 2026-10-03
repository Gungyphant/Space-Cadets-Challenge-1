#!/bin/bash
set -e  # Causes errors to terminate the script

if [ $1 = "-d" ]; then
	id=$2
	pretty=False
else
	id=$1
	pretty=True
fi

first_url=https://www.ecs.soton.ac.uk/people/$id
first_page=$(curl -s $first_url)

if [ -z "$first_page" ]; then
	echo "No staff member with that ID can be found"
	exit 1
fi

# The first page redirects to https://www.southampton.ac.uk/people/[id]
# The link it redirects to is in an <a> tag enclosed in quotes:
second_url=$(echo "$first_page" | grep "<a" | cut -f2 -d\")  # quotes around $first_page preserve the line breaks; grep finds the right line; cut gets the url from the tag
second_page=$(curl -s $second_url)

# The second page also redirects, this time to /people/[id]/[name]
# The name could be gotten on this page, but it might not match the name displayed on the website
third_url=https://www.southampton.ac.uk$(echo "$second_page" | grep "<a" | cut -f2 -d\")  # As the url omits the domain it must be manually added
third_page=$(curl -s $third_url)

third_page_length=$(echo "$third_page" | wc -l)

if [ $third_page_length -lt 2000 ]; then
	# Some pages are encoded with gzip
	third_page=$(curl -s $third_url | gunzip)  # For some reason echoing doesn't work here
fi

# The name is found in the only <h1> on the page:
name=$(echo "$third_page" | grep "<h1>" | cut -f2 -d\> | cut -f1 -d\<)  # it feels like there should be a better way than two cuts, but we haven't learnt it yet

# What seems to be the full name (sans title) can be found in the <meta property="og:title"> tag:
full_name=$(echo "$third_page" | grep "og:title" | cut -f4 -d\" | cut -f1 -d"|")

# Various information about the person can be found in the @graph's @type: Person section, as part of a json:
description=$(echo "$third_page" | grep -A14 "\"@type\": \"Person\"" | grep "description" | cut -f4 -d\")
jobTitle=$(echo "$third_page" | grep -A14 "\"@type\": \"Person\"" | grep "jobTitle" | cut -f4 -d\")
phone_number=$(echo "$third_page" | grep -A14 "\"@type\": \"Person\"" | grep "telephone" | cut -f4 -d\")

# The image url is within a subsection of the json so needs further parsing, and the "thumbnail" must be corrected to "max_1300x1300", and the domain must be added:
image_url=https://www.southampton.ac.uk$(echo "$third_page" | grep -A14 "\"@type\": \"Person\"" | grep -A1 "\"@type\": \"ImageObject\"" | grep "url" | cut -f4 -d\" | sed "s/thumbnail/max_1300x1300/g")

# The staff member's research interests are part of the html, so must be found via a more complex search
# First, the section of the page after the h3-d 'Research interests' title must be found, then the contents of the immediately succeeding <ul> (gotten with the next two
# greps), then each line of the list must be gotten (grep, cut), have its tags removed (cut, rev, cut (from what was previously the end), rev), and have "bullet points" 
# prepended (awk)
research_interests=$(echo "$third_page" | grep -A100000 "<h3>Research interests" | grep -A1000000 "<ul>" | grep -B10 "</ul>" -m 1 | grep "<li" | cut -f3 -d\" | cut -c 2- | rev | cut -c 6- | rev)


if [ $pretty = True ]; then
	echo "Name:         $name"
	echo "Full Name:    $full_name"
	echo "Description:  $description"
	echo "Job Title:    $jobTitle"
	echo "Phone Number: $phone_number"
	echo "Photo URL:    $image_url"
	if [ -n "$research_interests" ]; then
		printf "Research Interests:\n$(echo "$research_interests" | awk '{print "- " $0}')\n"  # printf handles \n better than echo
	fi
else
	echo "$name,$full_name,$description,$jobTitle,$phone_number,$image_url" $(echo "$research_interests" | awk '{print "," $0}')
fi

