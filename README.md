> Challenge 1: Write a program to extract a staff’s name (and/or other information) from their’s ID.

> <h3>Mission Brief</h3>
> The colonies have been attacked by an alien race and human civilisation has been decimated. It is known how many survivors are left and much of the infrastructure is still intact. You are onboard one of the few remaining vessels, on a team tasked with making contact with the surviving science team on earth to rebuild our research and development, and fight back.
>
> <h3>Your Task</h3>
> Have a look at the Web page at https://www.ecs.soton.ac.uk/people/dem. This is a institution information page which gives all sorts of information about a member of staff. The Web address is constructed from a departmental email id (in this case dem). If I have someone else's email id, I can look up their name from one of these Web pages. 
> 
> Write a program to find the name (and/or other information) about a from their ID.

source: https://moodle.ecs.soton.ac.uk/mod/page/view.php?id=44739

The bash script can be used by providing the email ID as the first (and only) argument, e.g.

```./Solution.sh dem```

Alternatively, the data can be gotten in a csv format with -d:

```./Solution.sh -d dem```

It will return:
- The staff member's name
- The staff member's full name
- The staff member's description
- The staff member's job title
- The staff member's work phone
- The URL for the staff member's official photo
- A list of the staff member's research interests
