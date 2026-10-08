> Challenge 1: Write a program to extract a staff’s name (and/or other information) from their’s ID.

> <h3>Mission Brief</h3>
> The colonies have been attacked by an alien race and human civilisation has been decimated. It is known how many survivors are left and much of the infrastructure is still intact. You are onboard one of the few remaining vessels, on a team tasked with making contact with the surviving science team on earth to rebuild our research and development, and fight back.
>
> <h3>Your Task</h3>
> Have a look at the Web page at https://www.ecs.soton.ac.uk/people/dem. This is a institution information page which gives all sorts of information about a member of staff. The Web address is constructed from a departmental email id (in this case dem). If I have someone else's email id, I can look up their name from one of these Web pages. 
> 
> Write a program to find the name (and/or other information) about a from their ID.

_source: https://moodle.ecs.soton.ac.uk/mod/page/view.php?id=44739_

### Bash solution:

The bash script can be used by providing the email ID as the first (and only) argument, e.g. ```./Solution.sh dem```

It will return:
- The staff member's name
- The staff member's full name
- The staff member's description
- The staff member's job title
- The staff member's work phone
- The URL for the staff member's official photo
- A list of the staff member's research interests

Alternatively, the data can be gotten in a csv format with -d ```./Bash\ Solution.sh -d dem```

For a demonstration with various IDs, run ```./Demonstrate\ bash\ solution.sh```


### Python solution:

_Prior to running the code for the first time, install the modules selenium, pillow (not PIL), and requests_

The Python code can be used by passing the ID as the only argument:

```
import Python_Solution
show_id_data("dem")
```

`show_id_data` also takes an optional second argument (defaults to True) that determines if the image should be shown

Alternatively, the data can be gotten as a dictionary via the other function:

```
import Python_Solution
get_id_data("dem")
```

For a demonstration with various IDs (with image displaying disabled), run the file

Note: for both solutions www.ecs.soton.ac.uk/people/ is used, so the staff member must be part of ECS and not another school
