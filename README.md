
<!-- README.md is generated from README.Rmd. Please edit that file -->

# inteRact

<!-- badges: start -->
<!-- badges: end -->

The goal of inteRact is to make affect control theory (ACT) equations
accessible to a broader audience of social scientists.

ACT is a theory of social behavior that hinges on the control principle
of people acting in ways to confirm cultural meaning. ACT theoretical
concepts have been used fruitfully in recent research within cultural
sociology (Hunzaker 2014, 2018), stratification and occupational
research (Freeland and Hoey 2018), social movements research (shuster
and Campos-Castillo. 2017), gender and victimization (Boyle and McKinzie
2015; Boyle and Walker 2016). Information about ACT as a theory can be
accessed here: <https://research.franklin.uga.edu/act/>

The goal of this package is to make elements of typical ACT analyses
easier to implement into R: calculating the deflection of an event, the
optimal behavior of an actor after an event, the relabeling of the actor
or object after an event, and calculating emotions within events. You
can look within the functions to see how the equations were programmed,
but to truly get a handle on the equations and how they work, I refer
you to Expressive Order (Heise 2010).

## Installation

You can install the development version from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("ekmaloney/inteRact")
```

## Example Analysis

The following analysis is an example of how to use this package to
implement ACT equations in your work. Functions can be applied to either
a single event or a dataframe of events, to make analyzing a larger
number of situations easier.

First, for any analysis you do, you need to ensure that the identities,
behaviors, and modifiers that you study are measured in the ACT
dictionary. inteRact includes the US dictionary that was measured in
2015 as the default dictionary (us\_2015\_full) and uses the US
equations as default for calculations.

Future versions will allow you to upload your own dictionaries and use
them in calculations.

The following code samples 20 identities and 10 behaviors to create a 10
event dataframe for the analysis.

``` r
library(inteRact)
library(kableExtra)
library(knitr)
library(tibble)
library(tidyverse)
#> ── Attaching packages ─────────────────────────────────────── tidyverse 1.3.0 ──
#> ✓ ggplot2 3.3.3     ✓ dplyr   1.0.6
#> ✓ tidyr   1.1.3     ✓ stringr 1.4.0
#> ✓ readr   1.4.0     ✓ forcats 0.5.1
#> ✓ purrr   0.3.4
#> ── Conflicts ────────────────────────────────────────── tidyverse_conflicts() ──
#> x dplyr::filter()     masks stats::filter()
#> x dplyr::group_rows() masks kableExtra::group_rows()
#> x dplyr::lag()        masks stats::lag()

#load US dict
data("us_2015_full")

#make a dataframe of events 
set.seed(814)
events <- tibble(actor = sample(us_2015_full$term[us_2015_full$type == "identity"], 10),
                 behavior = sample(us_2015_full$term[us_2015_full$type == "behavior"], 10),
                 object = sample(us_2015_full$term[us_2015_full$type == "identity"], 10))

kable(events, caption = "Sample Events for Analysis")
```

<table>
<caption>
Sample Events for Analysis
</caption>
<thead>
<tr>
<th style="text-align:left;">
actor
</th>
<th style="text-align:left;">
behavior
</th>
<th style="text-align:left;">
object
</th>
</tr>
</thead>
<tbody>
<tr>
<td style="text-align:left;">
brute
</td>
<td style="text-align:left;">
work
</td>
<td style="text-align:left;">
cook
</td>
</tr>
<tr>
<td style="text-align:left;">
dolt
</td>
<td style="text-align:left;">
say\_farewell\_to
</td>
<td style="text-align:left;">
executioner
</td>
</tr>
<tr>
<td style="text-align:left;">
husband
</td>
<td style="text-align:left;">
suck\_up\_to
</td>
<td style="text-align:left;">
trainee
</td>
</tr>
<tr>
<td style="text-align:left;">
sheet\_metal\_worker
</td>
<td style="text-align:left;">
debate\_with
</td>
<td style="text-align:left;">
junkie
</td>
</tr>
<tr>
<td style="text-align:left;">
hindu
</td>
<td style="text-align:left;">
beg
</td>
<td style="text-align:left;">
lout
</td>
</tr>
<tr>
<td style="text-align:left;">
casual\_laborer
</td>
<td style="text-align:left;">
deprecate
</td>
<td style="text-align:left;">
bailiff
</td>
</tr>
<tr>
<td style="text-align:left;">
housebreaker
</td>
<td style="text-align:left;">
implicate
</td>
<td style="text-align:left;">
welder
</td>
</tr>
<tr>
<td style="text-align:left;">
addict
</td>
<td style="text-align:left;">
suspect
</td>
<td style="text-align:left;">
assistant
</td>
</tr>
<tr>
<td style="text-align:left;">
millionaire
</td>
<td style="text-align:left;">
shock
</td>
<td style="text-align:left;">
machine\_repairer
</td>
</tr>
<tr>
<td style="text-align:left;">
hothead
</td>
<td style="text-align:left;">
refuse
</td>
<td style="text-align:left;">
blind\_person
</td>
</tr>
</tbody>
</table>

### Deflection

To calculate deflection for a single event, you can use the function
*calc\_deflection*, which has 4 arguments: actor, behavior, object (all
character strings), and dictionary (set to US currently). To calculate
deflection for a series of events, you can use the function
*batch\_deflection* which has 1 argument: a dataframe with an actor,
behavior, and object column (must be named that). For example, to find
the deflection of you would do the following:

``` r
d <- get_deflection("brute", "work", "cook", equation = "us")

print(d)
#> # A tibble: 1 x 1
#>       d
#>   <dbl>
#> 1  3.91
```

To calculate the deflection of all of the events in the sample events
dataframe, you would do the following:

``` r
events <- events %>% 
          rowwise() %>% 
          mutate(d = get_deflection(actor, behavior, object, equation = "us"),
                 d = d$d)

kable(events)
```

<table>
<thead>
<tr>
<th style="text-align:left;">
actor
</th>
<th style="text-align:left;">
behavior
</th>
<th style="text-align:left;">
object
</th>
<th style="text-align:right;">
d
</th>
</tr>
</thead>
<tbody>
<tr>
<td style="text-align:left;">
brute
</td>
<td style="text-align:left;">
work
</td>
<td style="text-align:left;">
cook
</td>
<td style="text-align:right;">
3.905718
</td>
</tr>
<tr>
<td style="text-align:left;">
dolt
</td>
<td style="text-align:left;">
say\_farewell\_to
</td>
<td style="text-align:left;">
executioner
</td>
<td style="text-align:right;">
3.507459
</td>
</tr>
<tr>
<td style="text-align:left;">
husband
</td>
<td style="text-align:left;">
suck\_up\_to
</td>
<td style="text-align:left;">
trainee
</td>
<td style="text-align:right;">
10.456399
</td>
</tr>
<tr>
<td style="text-align:left;">
sheet\_metal\_worker
</td>
<td style="text-align:left;">
debate\_with
</td>
<td style="text-align:left;">
junkie
</td>
<td style="text-align:right;">
3.434523
</td>
</tr>
<tr>
<td style="text-align:left;">
hindu
</td>
<td style="text-align:left;">
beg
</td>
<td style="text-align:left;">
lout
</td>
<td style="text-align:right;">
5.018938
</td>
</tr>
<tr>
<td style="text-align:left;">
casual\_laborer
</td>
<td style="text-align:left;">
deprecate
</td>
<td style="text-align:left;">
bailiff
</td>
<td style="text-align:right;">
7.195140
</td>
</tr>
<tr>
<td style="text-align:left;">
housebreaker
</td>
<td style="text-align:left;">
implicate
</td>
<td style="text-align:left;">
welder
</td>
<td style="text-align:right;">
2.245480
</td>
</tr>
<tr>
<td style="text-align:left;">
addict
</td>
<td style="text-align:left;">
suspect
</td>
<td style="text-align:left;">
assistant
</td>
<td style="text-align:right;">
3.943665
</td>
</tr>
<tr>
<td style="text-align:left;">
millionaire
</td>
<td style="text-align:left;">
shock
</td>
<td style="text-align:left;">
machine\_repairer
</td>
<td style="text-align:right;">
4.072882
</td>
</tr>
<tr>
<td style="text-align:left;">
hothead
</td>
<td style="text-align:left;">
refuse
</td>
<td style="text-align:left;">
blind\_person
</td>
<td style="text-align:right;">
2.707174
</td>
</tr>
</tbody>
</table>

### Element Deflection

Additionally, you can see which elements contribute the most to the
overall deflection by using the *element\_deflection* function, as
below. This returns a dataframe that includes each element’s fundamental
sentiment, the corresponding transient impression, the difference
between the two, and the squared difference. In this way, you can see
which element moved the most in EPA space after an event. In the case of
brute works cook, the most deflection element-dimension is the Power of
the Object (cook) followed by the Evaluation of the Actor (brute),

``` r
kable(element_deflection("brute", "work", "cook", equation = "us"), digits = 3)
```

<table>
<thead>
<tr>
<th style="text-align:left;">
term
</th>
<th style="text-align:left;">
element
</th>
<th style="text-align:left;">
dimension
</th>
<th style="text-align:right;">
fundamental\_sentiment
</th>
<th style="text-align:right;">
trans\_imp
</th>
<th style="text-align:right;">
difference
</th>
<th style="text-align:right;">
sqd\_diff
</th>
</tr>
</thead>
<tbody>
<tr>
<td style="text-align:left;">
brute
</td>
<td style="text-align:left;">
A
</td>
<td style="text-align:left;">
E
</td>
<td style="text-align:right;">
-1.97
</td>
<td style="text-align:right;">
-1.178
</td>
<td style="text-align:right;">
-0.792
</td>
<td style="text-align:right;">
0.626
</td>
</tr>
<tr>
<td style="text-align:left;">
brute
</td>
<td style="text-align:left;">
A
</td>
<td style="text-align:left;">
P
</td>
<td style="text-align:right;">
1.74
</td>
<td style="text-align:right;">
1.571
</td>
<td style="text-align:right;">
0.169
</td>
<td style="text-align:right;">
0.029
</td>
</tr>
<tr>
<td style="text-align:left;">
brute
</td>
<td style="text-align:left;">
A
</td>
<td style="text-align:left;">
A
</td>
<td style="text-align:right;">
1.44
</td>
<td style="text-align:right;">
1.148
</td>
<td style="text-align:right;">
0.292
</td>
<td style="text-align:right;">
0.085
</td>
</tr>
<tr>
<td style="text-align:left;">
work
</td>
<td style="text-align:left;">
B
</td>
<td style="text-align:left;">
E
</td>
<td style="text-align:right;">
0.27
</td>
<td style="text-align:right;">
-0.346
</td>
<td style="text-align:right;">
0.616
</td>
<td style="text-align:right;">
0.379
</td>
</tr>
<tr>
<td style="text-align:left;">
work
</td>
<td style="text-align:left;">
B
</td>
<td style="text-align:left;">
P
</td>
<td style="text-align:right;">
1.51
</td>
<td style="text-align:right;">
1.457
</td>
<td style="text-align:right;">
0.053
</td>
<td style="text-align:right;">
0.003
</td>
</tr>
<tr>
<td style="text-align:left;">
work
</td>
<td style="text-align:left;">
B
</td>
<td style="text-align:left;">
A
</td>
<td style="text-align:right;">
0.99
</td>
<td style="text-align:right;">
0.999
</td>
<td style="text-align:right;">
-0.009
</td>
<td style="text-align:right;">
0.000
</td>
</tr>
<tr>
<td style="text-align:left;">
cook
</td>
<td style="text-align:left;">
O
</td>
<td style="text-align:left;">
E
</td>
<td style="text-align:right;">
2.24
</td>
<td style="text-align:right;">
1.240
</td>
<td style="text-align:right;">
1.000
</td>
<td style="text-align:right;">
0.999
</td>
</tr>
<tr>
<td style="text-align:left;">
cook
</td>
<td style="text-align:left;">
O
</td>
<td style="text-align:left;">
P
</td>
<td style="text-align:right;">
1.69
</td>
<td style="text-align:right;">
0.464
</td>
<td style="text-align:right;">
1.226
</td>
<td style="text-align:right;">
1.504
</td>
</tr>
<tr>
<td style="text-align:left;">
cook
</td>
<td style="text-align:left;">
O
</td>
<td style="text-align:left;">
A
</td>
<td style="text-align:right;">
1.58
</td>
<td style="text-align:right;">
1.051
</td>
<td style="text-align:right;">
0.529
</td>
<td style="text-align:right;">
0.280
</td>
</tr>
</tbody>
</table>

You can do this for an entire dataframe with a little bit of nesting, as
follows:

``` r
elem_def <- events %>%
            rowwise() %>%
            mutate(el_def = list(element_deflection(actor, behavior, object, equation = "us"))) %>%
            unnest(el_def)

kable(elem_def)
```

<table>
<thead>
<tr>
<th style="text-align:left;">
actor
</th>
<th style="text-align:left;">
behavior
</th>
<th style="text-align:left;">
object
</th>
<th style="text-align:right;">
d
</th>
<th style="text-align:left;">
term
</th>
<th style="text-align:left;">
element
</th>
<th style="text-align:left;">
dimension
</th>
<th style="text-align:right;">
fundamental\_sentiment
</th>
<th style="text-align:right;">
trans\_imp
</th>
<th style="text-align:right;">
difference
</th>
<th style="text-align:right;">
sqd\_diff
</th>
</tr>
</thead>
<tbody>
<tr>
<td style="text-align:left;">
brute
</td>
<td style="text-align:left;">
work
</td>
<td style="text-align:left;">
cook
</td>
<td style="text-align:right;">
3.905718
</td>
<td style="text-align:left;">
brute
</td>
<td style="text-align:left;">
A
</td>
<td style="text-align:left;">
E
</td>
<td style="text-align:right;">
-1.97
</td>
<td style="text-align:right;">
-1.1784985
</td>
<td style="text-align:right;">
-0.7915015
</td>
<td style="text-align:right;">
0.6264747
</td>
</tr>
<tr>
<td style="text-align:left;">
brute
</td>
<td style="text-align:left;">
work
</td>
<td style="text-align:left;">
cook
</td>
<td style="text-align:right;">
3.905718
</td>
<td style="text-align:left;">
brute
</td>
<td style="text-align:left;">
A
</td>
<td style="text-align:left;">
P
</td>
<td style="text-align:right;">
1.74
</td>
<td style="text-align:right;">
1.5705780
</td>
<td style="text-align:right;">
0.1694220
</td>
<td style="text-align:right;">
0.0287038
</td>
</tr>
<tr>
<td style="text-align:left;">
brute
</td>
<td style="text-align:left;">
work
</td>
<td style="text-align:left;">
cook
</td>
<td style="text-align:right;">
3.905718
</td>
<td style="text-align:left;">
brute
</td>
<td style="text-align:left;">
A
</td>
<td style="text-align:left;">
A
</td>
<td style="text-align:right;">
1.44
</td>
<td style="text-align:right;">
1.1484640
</td>
<td style="text-align:right;">
0.2915360
</td>
<td style="text-align:right;">
0.0849932
</td>
</tr>
<tr>
<td style="text-align:left;">
brute
</td>
<td style="text-align:left;">
work
</td>
<td style="text-align:left;">
cook
</td>
<td style="text-align:right;">
3.905718
</td>
<td style="text-align:left;">
work
</td>
<td style="text-align:left;">
B
</td>
<td style="text-align:left;">
E
</td>
<td style="text-align:right;">
0.27
</td>
<td style="text-align:right;">
-0.3456641
</td>
<td style="text-align:right;">
0.6156641
</td>
<td style="text-align:right;">
0.3790423
</td>
</tr>
<tr>
<td style="text-align:left;">
brute
</td>
<td style="text-align:left;">
work
</td>
<td style="text-align:left;">
cook
</td>
<td style="text-align:right;">
3.905718
</td>
<td style="text-align:left;">
work
</td>
<td style="text-align:left;">
B
</td>
<td style="text-align:left;">
P
</td>
<td style="text-align:right;">
1.51
</td>
<td style="text-align:right;">
1.4572250
</td>
<td style="text-align:right;">
0.0527750
</td>
<td style="text-align:right;">
0.0027852
</td>
</tr>
<tr>
<td style="text-align:left;">
brute
</td>
<td style="text-align:left;">
work
</td>
<td style="text-align:left;">
cook
</td>
<td style="text-align:right;">
3.905718
</td>
<td style="text-align:left;">
work
</td>
<td style="text-align:left;">
B
</td>
<td style="text-align:left;">
A
</td>
<td style="text-align:right;">
0.99
</td>
<td style="text-align:right;">
0.9994000
</td>
<td style="text-align:right;">
-0.0094000
</td>
<td style="text-align:right;">
0.0000884
</td>
</tr>
<tr>
<td style="text-align:left;">
brute
</td>
<td style="text-align:left;">
work
</td>
<td style="text-align:left;">
cook
</td>
<td style="text-align:right;">
3.905718
</td>
<td style="text-align:left;">
cook
</td>
<td style="text-align:left;">
O
</td>
<td style="text-align:left;">
E
</td>
<td style="text-align:right;">
2.24
</td>
<td style="text-align:right;">
1.2402630
</td>
<td style="text-align:right;">
0.9997370
</td>
<td style="text-align:right;">
0.9994741
</td>
</tr>
<tr>
<td style="text-align:left;">
brute
</td>
<td style="text-align:left;">
work
</td>
<td style="text-align:left;">
cook
</td>
<td style="text-align:right;">
3.905718
</td>
<td style="text-align:left;">
cook
</td>
<td style="text-align:left;">
O
</td>
<td style="text-align:left;">
P
</td>
<td style="text-align:right;">
1.69
</td>
<td style="text-align:right;">
0.4635380
</td>
<td style="text-align:right;">
1.2264620
</td>
<td style="text-align:right;">
1.5042090
</td>
</tr>
<tr>
<td style="text-align:left;">
brute
</td>
<td style="text-align:left;">
work
</td>
<td style="text-align:left;">
cook
</td>
<td style="text-align:right;">
3.905718
</td>
<td style="text-align:left;">
cook
</td>
<td style="text-align:left;">
O
</td>
<td style="text-align:left;">
A
</td>
<td style="text-align:right;">
1.58
</td>
<td style="text-align:right;">
1.0509000
</td>
<td style="text-align:right;">
0.5291000
</td>
<td style="text-align:right;">
0.2799468
</td>
</tr>
<tr>
<td style="text-align:left;">
dolt
</td>
<td style="text-align:left;">
say\_farewell\_to
</td>
<td style="text-align:left;">
executioner
</td>
<td style="text-align:right;">
3.507459
</td>
<td style="text-align:left;">
dolt
</td>
<td style="text-align:left;">
A
</td>
<td style="text-align:left;">
E
</td>
<td style="text-align:right;">
-0.97
</td>
<td style="text-align:right;">
-0.5193836
</td>
<td style="text-align:right;">
-0.4506164
</td>
<td style="text-align:right;">
0.2030551
</td>
</tr>
<tr>
<td style="text-align:left;">
dolt
</td>
<td style="text-align:left;">
say\_farewell\_to
</td>
<td style="text-align:left;">
executioner
</td>
<td style="text-align:right;">
3.507459
</td>
<td style="text-align:left;">
dolt
</td>
<td style="text-align:left;">
A
</td>
<td style="text-align:left;">
P
</td>
<td style="text-align:right;">
-1.41
</td>
<td style="text-align:right;">
-0.6078640
</td>
<td style="text-align:right;">
-0.8021360
</td>
<td style="text-align:right;">
0.6434222
</td>
</tr>
<tr>
<td style="text-align:left;">
dolt
</td>
<td style="text-align:left;">
say\_farewell\_to
</td>
<td style="text-align:left;">
executioner
</td>
<td style="text-align:right;">
3.507459
</td>
<td style="text-align:left;">
dolt
</td>
<td style="text-align:left;">
A
</td>
<td style="text-align:left;">
A
</td>
<td style="text-align:right;">
-1.00
</td>
<td style="text-align:right;">
-0.8432000
</td>
<td style="text-align:right;">
-0.1568000
</td>
<td style="text-align:right;">
0.0245862
</td>
</tr>
<tr>
<td style="text-align:left;">
dolt
</td>
<td style="text-align:left;">
say\_farewell\_to
</td>
<td style="text-align:left;">
executioner
</td>
<td style="text-align:right;">
3.507459
</td>
<td style="text-align:left;">
say\_farewell\_to
</td>
<td style="text-align:left;">
B
</td>
<td style="text-align:left;">
E
</td>
<td style="text-align:right;">
-0.28
</td>
<td style="text-align:right;">
-0.0892146
</td>
<td style="text-align:right;">
-0.1907854
</td>
<td style="text-align:right;">
0.0363991
</td>
</tr>
<tr>
<td style="text-align:left;">
dolt
</td>
<td style="text-align:left;">
say\_farewell\_to
</td>
<td style="text-align:left;">
executioner
</td>
<td style="text-align:right;">
3.507459
</td>
<td style="text-align:left;">
say\_farewell\_to
</td>
<td style="text-align:left;">
B
</td>
<td style="text-align:left;">
P
</td>
<td style="text-align:right;">
0.76
</td>
<td style="text-align:right;">
0.3949840
</td>
<td style="text-align:right;">
0.3650160
</td>
<td style="text-align:right;">
0.1332367
</td>
</tr>
<tr>
<td style="text-align:left;">
dolt
</td>
<td style="text-align:left;">
say\_farewell\_to
</td>
<td style="text-align:left;">
executioner
</td>
<td style="text-align:right;">
3.507459
</td>
<td style="text-align:left;">
say\_farewell\_to
</td>
<td style="text-align:left;">
B
</td>
<td style="text-align:left;">
A
</td>
<td style="text-align:right;">
-0.89
</td>
<td style="text-align:right;">
-0.6756000
</td>
<td style="text-align:right;">
-0.2144000
</td>
<td style="text-align:right;">
0.0459674
</td>
</tr>
<tr>
<td style="text-align:left;">
dolt
</td>
<td style="text-align:left;">
say\_farewell\_to
</td>
<td style="text-align:left;">
executioner
</td>
<td style="text-align:right;">
3.507459
</td>
<td style="text-align:left;">
executioner
</td>
<td style="text-align:left;">
O
</td>
<td style="text-align:left;">
E
</td>
<td style="text-align:right;">
-1.77
</td>
<td style="text-align:right;">
-1.1446720
</td>
<td style="text-align:right;">
-0.6253280
</td>
<td style="text-align:right;">
0.3910351
</td>
</tr>
<tr>
<td style="text-align:left;">
dolt
</td>
<td style="text-align:left;">
say\_farewell\_to
</td>
<td style="text-align:left;">
executioner
</td>
<td style="text-align:right;">
3.507459
</td>
<td style="text-align:left;">
executioner
</td>
<td style="text-align:left;">
O
</td>
<td style="text-align:left;">
P
</td>
<td style="text-align:right;">
2.77
</td>
<td style="text-align:right;">
1.3696400
</td>
<td style="text-align:right;">
1.4003600
</td>
<td style="text-align:right;">
1.9610081
</td>
</tr>
<tr>
<td style="text-align:left;">
dolt
</td>
<td style="text-align:left;">
say\_farewell\_to
</td>
<td style="text-align:left;">
executioner
</td>
<td style="text-align:right;">
3.507459
</td>
<td style="text-align:left;">
executioner
</td>
<td style="text-align:left;">
O
</td>
<td style="text-align:left;">
A
</td>
<td style="text-align:right;">
0.25
</td>
<td style="text-align:right;">
-0.0122000
</td>
<td style="text-align:right;">
0.2622000
</td>
<td style="text-align:right;">
0.0687488
</td>
</tr>
<tr>
<td style="text-align:left;">
husband
</td>
<td style="text-align:left;">
suck\_up\_to
</td>
<td style="text-align:left;">
trainee
</td>
<td style="text-align:right;">
10.456399
</td>
<td style="text-align:left;">
husband
</td>
<td style="text-align:left;">
A
</td>
<td style="text-align:left;">
E
</td>
<td style="text-align:right;">
1.95
</td>
<td style="text-align:right;">
-0.7791492
</td>
<td style="text-align:right;">
2.7291492
</td>
<td style="text-align:right;">
7.4482554
</td>
</tr>
<tr>
<td style="text-align:left;">
husband
</td>
<td style="text-align:left;">
suck\_up\_to
</td>
<td style="text-align:left;">
trainee
</td>
<td style="text-align:right;">
10.456399
</td>
<td style="text-align:left;">
husband
</td>
<td style="text-align:left;">
A
</td>
<td style="text-align:left;">
P
</td>
<td style="text-align:right;">
1.64
</td>
<td style="text-align:right;">
0.4789640
</td>
<td style="text-align:right;">
1.1610360
</td>
<td style="text-align:right;">
1.3480046
</td>
</tr>
<tr>
<td style="text-align:left;">
husband
</td>
<td style="text-align:left;">
suck\_up\_to
</td>
<td style="text-align:left;">
trainee
</td>
<td style="text-align:right;">
10.456399
</td>
<td style="text-align:left;">
husband
</td>
<td style="text-align:left;">
A
</td>
<td style="text-align:left;">
A
</td>
<td style="text-align:right;">
0.38
</td>
<td style="text-align:right;">
0.6974840
</td>
<td style="text-align:right;">
-0.3174840
</td>
<td style="text-align:right;">
0.1007961
</td>
</tr>
<tr>
<td style="text-align:left;">
husband
</td>
<td style="text-align:left;">
suck\_up\_to
</td>
<td style="text-align:left;">
trainee
</td>
<td style="text-align:right;">
10.456399
</td>
<td style="text-align:left;">
suck\_up\_to
</td>
<td style="text-align:left;">
B
</td>
<td style="text-align:left;">
E
</td>
<td style="text-align:right;">
-1.52
</td>
<td style="text-align:right;">
-1.1916104
</td>
<td style="text-align:right;">
-0.3283896
</td>
<td style="text-align:right;">
0.1078397
</td>
</tr>
<tr>
<td style="text-align:left;">
husband
</td>
<td style="text-align:left;">
suck\_up\_to
</td>
<td style="text-align:left;">
trainee
</td>
<td style="text-align:right;">
10.456399
</td>
<td style="text-align:left;">
suck\_up\_to
</td>
<td style="text-align:left;">
B
</td>
<td style="text-align:left;">
P
</td>
<td style="text-align:right;">
-1.37
</td>
<td style="text-align:right;">
-0.4965680
</td>
<td style="text-align:right;">
-0.8734320
</td>
<td style="text-align:right;">
0.7628835
</td>
</tr>
<tr>
<td style="text-align:left;">
husband
</td>
<td style="text-align:left;">
suck\_up\_to
</td>
<td style="text-align:left;">
trainee
</td>
<td style="text-align:right;">
10.456399
</td>
<td style="text-align:left;">
suck\_up\_to
</td>
<td style="text-align:left;">
B
</td>
<td style="text-align:left;">
A
</td>
<td style="text-align:right;">
0.47
</td>
<td style="text-align:right;">
0.3932000
</td>
<td style="text-align:right;">
0.0768000
</td>
<td style="text-align:right;">
0.0058982
</td>
</tr>
<tr>
<td style="text-align:left;">
husband
</td>
<td style="text-align:left;">
suck\_up\_to
</td>
<td style="text-align:left;">
trainee
</td>
<td style="text-align:right;">
10.456399
</td>
<td style="text-align:left;">
trainee
</td>
<td style="text-align:left;">
O
</td>
<td style="text-align:left;">
E
</td>
<td style="text-align:right;">
0.88
</td>
<td style="text-align:right;">
0.1347440
</td>
<td style="text-align:right;">
0.7452560
</td>
<td style="text-align:right;">
0.5554065
</td>
</tr>
<tr>
<td style="text-align:left;">
husband
</td>
<td style="text-align:left;">
suck\_up\_to
</td>
<td style="text-align:left;">
trainee
</td>
<td style="text-align:right;">
10.456399
</td>
<td style="text-align:left;">
trainee
</td>
<td style="text-align:left;">
O
</td>
<td style="text-align:left;">
P
</td>
<td style="text-align:right;">
-1.42
</td>
<td style="text-align:right;">
-1.6165460
</td>
<td style="text-align:right;">
0.1965460
</td>
<td style="text-align:right;">
0.0386303
</td>
</tr>
<tr>
<td style="text-align:left;">
husband
</td>
<td style="text-align:left;">
suck\_up\_to
</td>
<td style="text-align:left;">
trainee
</td>
<td style="text-align:right;">
10.456399
</td>
<td style="text-align:left;">
trainee
</td>
<td style="text-align:left;">
O
</td>
<td style="text-align:left;">
A
</td>
<td style="text-align:right;">
-0.62
</td>
<td style="text-align:right;">
-0.3222000
</td>
<td style="text-align:right;">
-0.2978000
</td>
<td style="text-align:right;">
0.0886848
</td>
</tr>
<tr>
<td style="text-align:left;">
sheet\_metal\_worker
</td>
<td style="text-align:left;">
debate\_with
</td>
<td style="text-align:left;">
junkie
</td>
<td style="text-align:right;">
3.434523
</td>
<td style="text-align:left;">
sheet\_metal\_worker
</td>
<td style="text-align:left;">
A
</td>
<td style="text-align:left;">
E
</td>
<td style="text-align:right;">
0.91
</td>
<td style="text-align:right;">
0.1776507
</td>
<td style="text-align:right;">
0.7323493
</td>
<td style="text-align:right;">
0.5363355
</td>
</tr>
<tr>
<td style="text-align:left;">
sheet\_metal\_worker
</td>
<td style="text-align:left;">
debate\_with
</td>
<td style="text-align:left;">
junkie
</td>
<td style="text-align:right;">
3.434523
</td>
<td style="text-align:left;">
sheet\_metal\_worker
</td>
<td style="text-align:left;">
A
</td>
<td style="text-align:left;">
P
</td>
<td style="text-align:right;">
0.31
</td>
<td style="text-align:right;">
0.6883350
</td>
<td style="text-align:right;">
-0.3783350
</td>
<td style="text-align:right;">
0.1431374
</td>
</tr>
<tr>
<td style="text-align:left;">
sheet\_metal\_worker
</td>
<td style="text-align:left;">
debate\_with
</td>
<td style="text-align:left;">
junkie
</td>
<td style="text-align:right;">
3.434523
</td>
<td style="text-align:left;">
sheet\_metal\_worker
</td>
<td style="text-align:left;">
A
</td>
<td style="text-align:left;">
A
</td>
<td style="text-align:right;">
1.15
</td>
<td style="text-align:right;">
1.2525100
</td>
<td style="text-align:right;">
-0.1025100
</td>
<td style="text-align:right;">
0.0105083
</td>
</tr>
<tr>
<td style="text-align:left;">
sheet\_metal\_worker
</td>
<td style="text-align:left;">
debate\_with
</td>
<td style="text-align:left;">
junkie
</td>
<td style="text-align:right;">
3.434523
</td>
<td style="text-align:left;">
debate\_with
</td>
<td style="text-align:left;">
B
</td>
<td style="text-align:left;">
E
</td>
<td style="text-align:right;">
1.15
</td>
<td style="text-align:right;">
0.0807570
</td>
<td style="text-align:right;">
1.0692430
</td>
<td style="text-align:right;">
1.1432806
</td>
</tr>
<tr>
<td style="text-align:left;">
sheet\_metal\_worker
</td>
<td style="text-align:left;">
debate\_with
</td>
<td style="text-align:left;">
junkie
</td>
<td style="text-align:right;">
3.434523
</td>
<td style="text-align:left;">
debate\_with
</td>
<td style="text-align:left;">
B
</td>
<td style="text-align:left;">
P
</td>
<td style="text-align:right;">
1.73
</td>
<td style="text-align:right;">
1.0257150
</td>
<td style="text-align:right;">
0.7042850
</td>
<td style="text-align:right;">
0.4960174
</td>
</tr>
<tr>
<td style="text-align:left;">
sheet\_metal\_worker
</td>
<td style="text-align:left;">
debate\_with
</td>
<td style="text-align:left;">
junkie
</td>
<td style="text-align:right;">
3.434523
</td>
<td style="text-align:left;">
debate\_with
</td>
<td style="text-align:left;">
B
</td>
<td style="text-align:left;">
A
</td>
<td style="text-align:right;">
1.81
</td>
<td style="text-align:right;">
1.6245000
</td>
<td style="text-align:right;">
0.1855000
</td>
<td style="text-align:right;">
0.0344102
</td>
</tr>
<tr>
<td style="text-align:left;">
sheet\_metal\_worker
</td>
<td style="text-align:left;">
debate\_with
</td>
<td style="text-align:left;">
junkie
</td>
<td style="text-align:right;">
3.434523
</td>
<td style="text-align:left;">
junkie
</td>
<td style="text-align:left;">
O
</td>
<td style="text-align:left;">
E
</td>
<td style="text-align:right;">
-2.10
</td>
<td style="text-align:right;">
-1.2219150
</td>
<td style="text-align:right;">
-0.8780850
</td>
<td style="text-align:right;">
0.7710333
</td>
</tr>
<tr>
<td style="text-align:left;">
sheet\_metal\_worker
</td>
<td style="text-align:left;">
debate\_with
</td>
<td style="text-align:left;">
junkie
</td>
<td style="text-align:right;">
3.434523
</td>
<td style="text-align:left;">
junkie
</td>
<td style="text-align:left;">
O
</td>
<td style="text-align:left;">
P
</td>
<td style="text-align:right;">
-2.04
</td>
<td style="text-align:right;">
-1.5008700
</td>
<td style="text-align:right;">
-0.5391300
</td>
<td style="text-align:right;">
0.2906612
</td>
</tr>
<tr>
<td style="text-align:left;">
sheet\_metal\_worker
</td>
<td style="text-align:left;">
debate\_with
</td>
<td style="text-align:left;">
junkie
</td>
<td style="text-align:right;">
3.434523
</td>
<td style="text-align:left;">
junkie
</td>
<td style="text-align:left;">
O
</td>
<td style="text-align:left;">
A
</td>
<td style="text-align:right;">
-0.04
</td>
<td style="text-align:right;">
0.0556000
</td>
<td style="text-align:right;">
-0.0956000
</td>
<td style="text-align:right;">
0.0091394
</td>
</tr>
<tr>
<td style="text-align:left;">
hindu
</td>
<td style="text-align:left;">
beg
</td>
<td style="text-align:left;">
lout
</td>
<td style="text-align:right;">
5.018938
</td>
<td style="text-align:left;">
hindu
</td>
<td style="text-align:left;">
A
</td>
<td style="text-align:left;">
E
</td>
<td style="text-align:right;">
0.76
</td>
<td style="text-align:right;">
-0.6721397
</td>
<td style="text-align:right;">
1.4321397
</td>
<td style="text-align:right;">
2.0510241
</td>
</tr>
<tr>
<td style="text-align:left;">
hindu
</td>
<td style="text-align:left;">
beg
</td>
<td style="text-align:left;">
lout
</td>
<td style="text-align:right;">
5.018938
</td>
<td style="text-align:left;">
hindu
</td>
<td style="text-align:left;">
A
</td>
<td style="text-align:left;">
P
</td>
<td style="text-align:right;">
0.14
</td>
<td style="text-align:right;">
-0.8492180
</td>
<td style="text-align:right;">
0.9892180
</td>
<td style="text-align:right;">
0.9785523
</td>
</tr>
<tr>
<td style="text-align:left;">
hindu
</td>
<td style="text-align:left;">
beg
</td>
<td style="text-align:left;">
lout
</td>
<td style="text-align:right;">
5.018938
</td>
<td style="text-align:left;">
hindu
</td>
<td style="text-align:left;">
A
</td>
<td style="text-align:left;">
A
</td>
<td style="text-align:right;">
-0.66
</td>
<td style="text-align:right;">
0.0844160
</td>
<td style="text-align:right;">
-0.7444160
</td>
<td style="text-align:right;">
0.5541552
</td>
</tr>
<tr>
<td style="text-align:left;">
hindu
</td>
<td style="text-align:left;">
beg
</td>
<td style="text-align:left;">
lout
</td>
<td style="text-align:right;">
5.018938
</td>
<td style="text-align:left;">
beg
</td>
<td style="text-align:left;">
B
</td>
<td style="text-align:left;">
E
</td>
<td style="text-align:right;">
-1.58
</td>
<td style="text-align:right;">
-0.9170182
</td>
<td style="text-align:right;">
-0.6629818
</td>
<td style="text-align:right;">
0.4395449
</td>
</tr>
<tr>
<td style="text-align:left;">
hindu
</td>
<td style="text-align:left;">
beg
</td>
<td style="text-align:left;">
lout
</td>
<td style="text-align:right;">
5.018938
</td>
<td style="text-align:left;">
beg
</td>
<td style="text-align:left;">
B
</td>
<td style="text-align:left;">
P
</td>
<td style="text-align:right;">
-2.02
</td>
<td style="text-align:right;">
-1.1243820
</td>
<td style="text-align:right;">
-0.8956180
</td>
<td style="text-align:right;">
0.8021316
</td>
</tr>
<tr>
<td style="text-align:left;">
hindu
</td>
<td style="text-align:left;">
beg
</td>
<td style="text-align:left;">
lout
</td>
<td style="text-align:right;">
5.018938
</td>
<td style="text-align:left;">
beg
</td>
<td style="text-align:left;">
B
</td>
<td style="text-align:left;">
A
</td>
<td style="text-align:right;">
0.71
</td>
<td style="text-align:right;">
0.3298000
</td>
<td style="text-align:right;">
0.3802000
</td>
<td style="text-align:right;">
0.1445520
</td>
</tr>
<tr>
<td style="text-align:left;">
hindu
</td>
<td style="text-align:left;">
beg
</td>
<td style="text-align:left;">
lout
</td>
<td style="text-align:right;">
5.018938
</td>
<td style="text-align:left;">
lout
</td>
<td style="text-align:left;">
O
</td>
<td style="text-align:left;">
E
</td>
<td style="text-align:right;">
-0.99
</td>
<td style="text-align:right;">
-0.9187500
</td>
<td style="text-align:right;">
-0.0712500
</td>
<td style="text-align:right;">
0.0050766
</td>
</tr>
<tr>
<td style="text-align:left;">
hindu
</td>
<td style="text-align:left;">
beg
</td>
<td style="text-align:left;">
lout
</td>
<td style="text-align:right;">
5.018938
</td>
<td style="text-align:left;">
lout
</td>
<td style="text-align:left;">
O
</td>
<td style="text-align:left;">
P
</td>
<td style="text-align:right;">
-0.34
</td>
<td style="text-align:right;">
-0.5430980
</td>
<td style="text-align:right;">
0.2030980
</td>
<td style="text-align:right;">
0.0412488
</td>
</tr>
<tr>
<td style="text-align:left;">
hindu
</td>
<td style="text-align:left;">
beg
</td>
<td style="text-align:left;">
lout
</td>
<td style="text-align:right;">
5.018938
</td>
<td style="text-align:left;">
lout
</td>
<td style="text-align:left;">
O
</td>
<td style="text-align:left;">
A
</td>
<td style="text-align:right;">
0.08
</td>
<td style="text-align:right;">
0.0285000
</td>
<td style="text-align:right;">
0.0515000
</td>
<td style="text-align:right;">
0.0026522
</td>
</tr>
<tr>
<td style="text-align:left;">
casual\_laborer
</td>
<td style="text-align:left;">
deprecate
</td>
<td style="text-align:left;">
bailiff
</td>
<td style="text-align:right;">
7.195140
</td>
<td style="text-align:left;">
casual\_laborer
</td>
<td style="text-align:left;">
A
</td>
<td style="text-align:left;">
E
</td>
<td style="text-align:right;">
0.77
</td>
<td style="text-align:right;">
-0.9140124
</td>
<td style="text-align:right;">
1.6840124
</td>
<td style="text-align:right;">
2.8358978
</td>
</tr>
<tr>
<td style="text-align:left;">
casual\_laborer
</td>
<td style="text-align:left;">
deprecate
</td>
<td style="text-align:left;">
bailiff
</td>
<td style="text-align:right;">
7.195140
</td>
<td style="text-align:left;">
casual\_laborer
</td>
<td style="text-align:left;">
A
</td>
<td style="text-align:left;">
P
</td>
<td style="text-align:right;">
-0.42
</td>
<td style="text-align:right;">
-0.0819800
</td>
<td style="text-align:right;">
-0.3380200
</td>
<td style="text-align:right;">
0.1142575
</td>
</tr>
<tr>
<td style="text-align:left;">
casual\_laborer
</td>
<td style="text-align:left;">
deprecate
</td>
<td style="text-align:left;">
bailiff
</td>
<td style="text-align:right;">
7.195140
</td>
<td style="text-align:left;">
casual\_laborer
</td>
<td style="text-align:left;">
A
</td>
<td style="text-align:left;">
A
</td>
<td style="text-align:right;">
-0.05
</td>
<td style="text-align:right;">
0.4427200
</td>
<td style="text-align:right;">
-0.4927200
</td>
<td style="text-align:right;">
0.2427730
</td>
</tr>
<tr>
<td style="text-align:left;">
casual\_laborer
</td>
<td style="text-align:left;">
deprecate
</td>
<td style="text-align:left;">
bailiff
</td>
<td style="text-align:right;">
7.195140
</td>
<td style="text-align:left;">
deprecate
</td>
<td style="text-align:left;">
B
</td>
<td style="text-align:left;">
E
</td>
<td style="text-align:right;">
-2.30
</td>
<td style="text-align:right;">
-1.3419544
</td>
<td style="text-align:right;">
-0.9580456
</td>
<td style="text-align:right;">
0.9178514
</td>
</tr>
<tr>
<td style="text-align:left;">
casual\_laborer
</td>
<td style="text-align:left;">
deprecate
</td>
<td style="text-align:left;">
bailiff
</td>
<td style="text-align:right;">
7.195140
</td>
<td style="text-align:left;">
deprecate
</td>
<td style="text-align:left;">
B
</td>
<td style="text-align:left;">
P
</td>
<td style="text-align:right;">
0.18
</td>
<td style="text-align:right;">
0.3876100
</td>
<td style="text-align:right;">
-0.2076100
</td>
<td style="text-align:right;">
0.0431019
</td>
</tr>
<tr>
<td style="text-align:left;">
casual\_laborer
</td>
<td style="text-align:left;">
deprecate
</td>
<td style="text-align:left;">
bailiff
</td>
<td style="text-align:right;">
7.195140
</td>
<td style="text-align:left;">
deprecate
</td>
<td style="text-align:left;">
B
</td>
<td style="text-align:left;">
A
</td>
<td style="text-align:right;">
0.54
</td>
<td style="text-align:right;">
0.3907000
</td>
<td style="text-align:right;">
0.1493000
</td>
<td style="text-align:right;">
0.0222905
</td>
</tr>
<tr>
<td style="text-align:left;">
casual\_laborer
</td>
<td style="text-align:left;">
deprecate
</td>
<td style="text-align:left;">
bailiff
</td>
<td style="text-align:right;">
7.195140
</td>
<td style="text-align:left;">
bailiff
</td>
<td style="text-align:left;">
O
</td>
<td style="text-align:left;">
E
</td>
<td style="text-align:right;">
0.72
</td>
<td style="text-align:right;">
-0.0440580
</td>
<td style="text-align:right;">
0.7640580
</td>
<td style="text-align:right;">
0.5837846
</td>
</tr>
<tr>
<td style="text-align:left;">
casual\_laborer
</td>
<td style="text-align:left;">
deprecate
</td>
<td style="text-align:left;">
bailiff
</td>
<td style="text-align:right;">
7.195140
</td>
<td style="text-align:left;">
bailiff
</td>
<td style="text-align:left;">
O
</td>
<td style="text-align:left;">
P
</td>
<td style="text-align:right;">
1.56
</td>
<td style="text-align:right;">
0.0038400
</td>
<td style="text-align:right;">
1.5561600
</td>
<td style="text-align:right;">
2.4216339
</td>
</tr>
<tr>
<td style="text-align:left;">
casual\_laborer
</td>
<td style="text-align:left;">
deprecate
</td>
<td style="text-align:left;">
bailiff
</td>
<td style="text-align:right;">
7.195140
</td>
<td style="text-align:left;">
bailiff
</td>
<td style="text-align:left;">
O
</td>
<td style="text-align:left;">
A
</td>
<td style="text-align:right;">
0.10
</td>
<td style="text-align:right;">
-0.0164000
</td>
<td style="text-align:right;">
0.1164000
</td>
<td style="text-align:right;">
0.0135490
</td>
</tr>
<tr>
<td style="text-align:left;">
housebreaker
</td>
<td style="text-align:left;">
implicate
</td>
<td style="text-align:left;">
welder
</td>
<td style="text-align:right;">
2.245480
</td>
<td style="text-align:left;">
housebreaker
</td>
<td style="text-align:left;">
A
</td>
<td style="text-align:left;">
E
</td>
<td style="text-align:right;">
-2.82
</td>
<td style="text-align:right;">
-1.7520233
</td>
<td style="text-align:right;">
-1.0679767
</td>
<td style="text-align:right;">
1.1405743
</td>
</tr>
<tr>
<td style="text-align:left;">
housebreaker
</td>
<td style="text-align:left;">
implicate
</td>
<td style="text-align:left;">
welder
</td>
<td style="text-align:right;">
2.245480
</td>
<td style="text-align:left;">
housebreaker
</td>
<td style="text-align:left;">
A
</td>
<td style="text-align:left;">
P
</td>
<td style="text-align:right;">
0.84
</td>
<td style="text-align:right;">
0.8021120
</td>
<td style="text-align:right;">
0.0378880
</td>
<td style="text-align:right;">
0.0014355
</td>
</tr>
<tr>
<td style="text-align:left;">
housebreaker
</td>
<td style="text-align:left;">
implicate
</td>
<td style="text-align:left;">
welder
</td>
<td style="text-align:right;">
2.245480
</td>
<td style="text-align:left;">
housebreaker
</td>
<td style="text-align:left;">
A
</td>
<td style="text-align:left;">
A
</td>
<td style="text-align:right;">
0.74
</td>
<td style="text-align:right;">
0.6477120
</td>
<td style="text-align:right;">
0.0922880
</td>
<td style="text-align:right;">
0.0085171
</td>
</tr>
<tr>
<td style="text-align:left;">
housebreaker
</td>
<td style="text-align:left;">
implicate
</td>
<td style="text-align:left;">
welder
</td>
<td style="text-align:right;">
2.245480
</td>
<td style="text-align:left;">
implicate
</td>
<td style="text-align:left;">
B
</td>
<td style="text-align:left;">
E
</td>
<td style="text-align:right;">
-0.79
</td>
<td style="text-align:right;">
-0.9885955
</td>
<td style="text-align:right;">
0.1985955
</td>
<td style="text-align:right;">
0.0394402
</td>
</tr>
<tr>
<td style="text-align:left;">
housebreaker
</td>
<td style="text-align:left;">
implicate
</td>
<td style="text-align:left;">
welder
</td>
<td style="text-align:right;">
2.245480
</td>
<td style="text-align:left;">
implicate
</td>
<td style="text-align:left;">
B
</td>
<td style="text-align:left;">
P
</td>
<td style="text-align:right;">
0.76
</td>
<td style="text-align:right;">
0.8622740
</td>
<td style="text-align:right;">
-0.1022740
</td>
<td style="text-align:right;">
0.0104600
</td>
</tr>
<tr>
<td style="text-align:left;">
housebreaker
</td>
<td style="text-align:left;">
implicate
</td>
<td style="text-align:left;">
welder
</td>
<td style="text-align:right;">
2.245480
</td>
<td style="text-align:left;">
implicate
</td>
<td style="text-align:left;">
B
</td>
<td style="text-align:left;">
A
</td>
<td style="text-align:right;">
0.52
</td>
<td style="text-align:right;">
0.5042000
</td>
<td style="text-align:right;">
0.0158000
</td>
<td style="text-align:right;">
0.0002496
</td>
</tr>
<tr>
<td style="text-align:left;">
housebreaker
</td>
<td style="text-align:left;">
implicate
</td>
<td style="text-align:left;">
welder
</td>
<td style="text-align:right;">
2.245480
</td>
<td style="text-align:left;">
welder
</td>
<td style="text-align:left;">
O
</td>
<td style="text-align:left;">
E
</td>
<td style="text-align:right;">
0.92
</td>
<td style="text-align:right;">
0.4074860
</td>
<td style="text-align:right;">
0.5125140
</td>
<td style="text-align:right;">
0.2626706
</td>
</tr>
<tr>
<td style="text-align:left;">
housebreaker
</td>
<td style="text-align:left;">
implicate
</td>
<td style="text-align:left;">
welder
</td>
<td style="text-align:right;">
2.245480
</td>
<td style="text-align:left;">
welder
</td>
<td style="text-align:left;">
O
</td>
<td style="text-align:left;">
P
</td>
<td style="text-align:right;">
0.51
</td>
<td style="text-align:right;">
-0.3244710
</td>
<td style="text-align:right;">
0.8344710
</td>
<td style="text-align:right;">
0.6963418
</td>
</tr>
<tr>
<td style="text-align:left;">
housebreaker
</td>
<td style="text-align:left;">
implicate
</td>
<td style="text-align:left;">
welder
</td>
<td style="text-align:right;">
2.245480
</td>
<td style="text-align:left;">
welder
</td>
<td style="text-align:left;">
O
</td>
<td style="text-align:left;">
A
</td>
<td style="text-align:right;">
0.88
</td>
<td style="text-align:right;">
0.5871000
</td>
<td style="text-align:right;">
0.2929000
</td>
<td style="text-align:right;">
0.0857904
</td>
</tr>
<tr>
<td style="text-align:left;">
addict
</td>
<td style="text-align:left;">
suspect
</td>
<td style="text-align:left;">
assistant
</td>
<td style="text-align:right;">
3.943665
</td>
<td style="text-align:left;">
addict
</td>
<td style="text-align:left;">
A
</td>
<td style="text-align:left;">
E
</td>
<td style="text-align:right;">
-2.23
</td>
<td style="text-align:right;">
-1.4536101
</td>
<td style="text-align:right;">
-0.7763899
</td>
<td style="text-align:right;">
0.6027813
</td>
</tr>
<tr>
<td style="text-align:left;">
addict
</td>
<td style="text-align:left;">
suspect
</td>
<td style="text-align:left;">
assistant
</td>
<td style="text-align:right;">
3.943665
</td>
<td style="text-align:left;">
addict
</td>
<td style="text-align:left;">
A
</td>
<td style="text-align:left;">
P
</td>
<td style="text-align:right;">
-2.36
</td>
<td style="text-align:right;">
-1.0012660
</td>
<td style="text-align:right;">
-1.3587340
</td>
<td style="text-align:right;">
1.8461581
</td>
</tr>
<tr>
<td style="text-align:left;">
addict
</td>
<td style="text-align:left;">
suspect
</td>
<td style="text-align:left;">
assistant
</td>
<td style="text-align:right;">
3.943665
</td>
<td style="text-align:left;">
addict
</td>
<td style="text-align:left;">
A
</td>
<td style="text-align:left;">
A
</td>
<td style="text-align:right;">
0.19
</td>
<td style="text-align:right;">
0.0317540
</td>
<td style="text-align:right;">
0.1582460
</td>
<td style="text-align:right;">
0.0250418
</td>
</tr>
<tr>
<td style="text-align:left;">
addict
</td>
<td style="text-align:left;">
suspect
</td>
<td style="text-align:left;">
assistant
</td>
<td style="text-align:right;">
3.943665
</td>
<td style="text-align:left;">
suspect
</td>
<td style="text-align:left;">
B
</td>
<td style="text-align:left;">
E
</td>
<td style="text-align:right;">
-0.86
</td>
<td style="text-align:right;">
-0.9284364
</td>
<td style="text-align:right;">
0.0684364
</td>
<td style="text-align:right;">
0.0046835
</td>
</tr>
<tr>
<td style="text-align:left;">
addict
</td>
<td style="text-align:left;">
suspect
</td>
<td style="text-align:left;">
assistant
</td>
<td style="text-align:right;">
3.943665
</td>
<td style="text-align:left;">
suspect
</td>
<td style="text-align:left;">
B
</td>
<td style="text-align:left;">
P
</td>
<td style="text-align:right;">
0.54
</td>
<td style="text-align:right;">
0.1967200
</td>
<td style="text-align:right;">
0.3432800
</td>
<td style="text-align:right;">
0.1178412
</td>
</tr>
<tr>
<td style="text-align:left;">
addict
</td>
<td style="text-align:left;">
suspect
</td>
<td style="text-align:left;">
assistant
</td>
<td style="text-align:right;">
3.943665
</td>
<td style="text-align:left;">
suspect
</td>
<td style="text-align:left;">
B
</td>
<td style="text-align:left;">
A
</td>
<td style="text-align:right;">
-0.61
</td>
<td style="text-align:right;">
-0.1665000
</td>
<td style="text-align:right;">
-0.4435000
</td>
<td style="text-align:right;">
0.1966922
</td>
</tr>
<tr>
<td style="text-align:left;">
addict
</td>
<td style="text-align:left;">
suspect
</td>
<td style="text-align:left;">
assistant
</td>
<td style="text-align:right;">
3.943665
</td>
<td style="text-align:left;">
assistant
</td>
<td style="text-align:left;">
O
</td>
<td style="text-align:left;">
E
</td>
<td style="text-align:right;">
1.51
</td>
<td style="text-align:right;">
0.6991280
</td>
<td style="text-align:right;">
0.8108720
</td>
<td style="text-align:right;">
0.6575134
</td>
</tr>
<tr>
<td style="text-align:left;">
addict
</td>
<td style="text-align:left;">
suspect
</td>
<td style="text-align:left;">
assistant
</td>
<td style="text-align:right;">
3.943665
</td>
<td style="text-align:left;">
assistant
</td>
<td style="text-align:left;">
O
</td>
<td style="text-align:left;">
P
</td>
<td style="text-align:right;">
-0.10
</td>
<td style="text-align:right;">
-0.8011780
</td>
<td style="text-align:right;">
0.7011780
</td>
<td style="text-align:right;">
0.4916506
</td>
</tr>
<tr>
<td style="text-align:left;">
addict
</td>
<td style="text-align:left;">
suspect
</td>
<td style="text-align:left;">
assistant
</td>
<td style="text-align:right;">
3.943665
</td>
<td style="text-align:left;">
assistant
</td>
<td style="text-align:left;">
O
</td>
<td style="text-align:left;">
A
</td>
<td style="text-align:right;">
0.05
</td>
<td style="text-align:right;">
0.0861000
</td>
<td style="text-align:right;">
-0.0361000
</td>
<td style="text-align:right;">
0.0013032
</td>
</tr>
<tr>
<td style="text-align:left;">
millionaire
</td>
<td style="text-align:left;">
shock
</td>
<td style="text-align:left;">
machine\_repairer
</td>
<td style="text-align:right;">
4.072882
</td>
<td style="text-align:left;">
millionaire
</td>
<td style="text-align:left;">
A
</td>
<td style="text-align:left;">
E
</td>
<td style="text-align:right;">
0.57
</td>
<td style="text-align:right;">
-0.6074843
</td>
<td style="text-align:right;">
1.1774843
</td>
<td style="text-align:right;">
1.3864693
</td>
</tr>
<tr>
<td style="text-align:left;">
millionaire
</td>
<td style="text-align:left;">
shock
</td>
<td style="text-align:left;">
machine\_repairer
</td>
<td style="text-align:right;">
4.072882
</td>
<td style="text-align:left;">
millionaire
</td>
<td style="text-align:left;">
A
</td>
<td style="text-align:left;">
P
</td>
<td style="text-align:right;">
2.50
</td>
<td style="text-align:right;">
1.9123160
</td>
<td style="text-align:right;">
0.5876840
</td>
<td style="text-align:right;">
0.3453725
</td>
</tr>
<tr>
<td style="text-align:left;">
millionaire
</td>
<td style="text-align:left;">
shock
</td>
<td style="text-align:left;">
machine\_repairer
</td>
<td style="text-align:right;">
4.072882
</td>
<td style="text-align:left;">
millionaire
</td>
<td style="text-align:left;">
A
</td>
<td style="text-align:left;">
A
</td>
<td style="text-align:right;">
1.09
</td>
<td style="text-align:right;">
1.3095340
</td>
<td style="text-align:right;">
-0.2195340
</td>
<td style="text-align:right;">
0.0481952
</td>
</tr>
<tr>
<td style="text-align:left;">
millionaire
</td>
<td style="text-align:left;">
shock
</td>
<td style="text-align:left;">
machine\_repairer
</td>
<td style="text-align:right;">
4.072882
</td>
<td style="text-align:left;">
shock
</td>
<td style="text-align:left;">
B
</td>
<td style="text-align:left;">
E
</td>
<td style="text-align:right;">
-0.69
</td>
<td style="text-align:right;">
-0.7746998
</td>
<td style="text-align:right;">
0.0846998
</td>
<td style="text-align:right;">
0.0071740
</td>
</tr>
<tr>
<td style="text-align:left;">
millionaire
</td>
<td style="text-align:left;">
shock
</td>
<td style="text-align:left;">
machine\_repairer
</td>
<td style="text-align:right;">
4.072882
</td>
<td style="text-align:left;">
shock
</td>
<td style="text-align:left;">
B
</td>
<td style="text-align:left;">
P
</td>
<td style="text-align:right;">
1.44
</td>
<td style="text-align:right;">
1.5766150
</td>
<td style="text-align:right;">
-0.1366150
</td>
<td style="text-align:right;">
0.0186637
</td>
</tr>
<tr>
<td style="text-align:left;">
millionaire
</td>
<td style="text-align:left;">
shock
</td>
<td style="text-align:left;">
machine\_repairer
</td>
<td style="text-align:right;">
4.072882
</td>
<td style="text-align:left;">
shock
</td>
<td style="text-align:left;">
B
</td>
<td style="text-align:left;">
A
</td>
<td style="text-align:right;">
1.79
</td>
<td style="text-align:right;">
1.3837000
</td>
<td style="text-align:right;">
0.4063000
</td>
<td style="text-align:right;">
0.1650797
</td>
</tr>
<tr>
<td style="text-align:left;">
millionaire
</td>
<td style="text-align:left;">
shock
</td>
<td style="text-align:left;">
machine\_repairer
</td>
<td style="text-align:right;">
4.072882
</td>
<td style="text-align:left;">
machine\_repairer
</td>
<td style="text-align:left;">
O
</td>
<td style="text-align:left;">
E
</td>
<td style="text-align:right;">
1.36
</td>
<td style="text-align:right;">
0.5560130
</td>
<td style="text-align:right;">
0.8039870
</td>
<td style="text-align:right;">
0.6463951
</td>
</tr>
<tr>
<td style="text-align:left;">
millionaire
</td>
<td style="text-align:left;">
shock
</td>
<td style="text-align:left;">
machine\_repairer
</td>
<td style="text-align:right;">
4.072882
</td>
<td style="text-align:left;">
machine\_repairer
</td>
<td style="text-align:left;">
O
</td>
<td style="text-align:left;">
P
</td>
<td style="text-align:right;">
1.02
</td>
<td style="text-align:right;">
-0.1633060
</td>
<td style="text-align:right;">
1.1833060
</td>
<td style="text-align:right;">
1.4002131
</td>
</tr>
<tr>
<td style="text-align:left;">
millionaire
</td>
<td style="text-align:left;">
shock
</td>
<td style="text-align:left;">
machine\_repairer
</td>
<td style="text-align:right;">
4.072882
</td>
<td style="text-align:left;">
machine\_repairer
</td>
<td style="text-align:left;">
O
</td>
<td style="text-align:left;">
A
</td>
<td style="text-align:right;">
0.68
</td>
<td style="text-align:right;">
0.4448000
</td>
<td style="text-align:right;">
0.2352000
</td>
<td style="text-align:right;">
0.0553190
</td>
</tr>
<tr>
<td style="text-align:left;">
hothead
</td>
<td style="text-align:left;">
refuse
</td>
<td style="text-align:left;">
blind\_person
</td>
<td style="text-align:right;">
2.707174
</td>
<td style="text-align:left;">
hothead
</td>
<td style="text-align:left;">
A
</td>
<td style="text-align:left;">
E
</td>
<td style="text-align:right;">
-1.92
</td>
<td style="text-align:right;">
-1.4910576
</td>
<td style="text-align:right;">
-0.4289424
</td>
<td style="text-align:right;">
0.1839916
</td>
</tr>
<tr>
<td style="text-align:left;">
hothead
</td>
<td style="text-align:left;">
refuse
</td>
<td style="text-align:left;">
blind\_person
</td>
<td style="text-align:right;">
2.707174
</td>
<td style="text-align:left;">
hothead
</td>
<td style="text-align:left;">
A
</td>
<td style="text-align:left;">
P
</td>
<td style="text-align:right;">
-0.42
</td>
<td style="text-align:right;">
0.4915250
</td>
<td style="text-align:right;">
-0.9115250
</td>
<td style="text-align:right;">
0.8308778
</td>
</tr>
<tr>
<td style="text-align:left;">
hothead
</td>
<td style="text-align:left;">
refuse
</td>
<td style="text-align:left;">
blind\_person
</td>
<td style="text-align:right;">
2.707174
</td>
<td style="text-align:left;">
hothead
</td>
<td style="text-align:left;">
A
</td>
<td style="text-align:left;">
A
</td>
<td style="text-align:right;">
2.59
</td>
<td style="text-align:right;">
1.8399440
</td>
<td style="text-align:right;">
0.7500560
</td>
<td style="text-align:right;">
0.5625840
</td>
</tr>
<tr>
<td style="text-align:left;">
hothead
</td>
<td style="text-align:left;">
refuse
</td>
<td style="text-align:left;">
blind\_person
</td>
<td style="text-align:right;">
2.707174
</td>
<td style="text-align:left;">
refuse
</td>
<td style="text-align:left;">
B
</td>
<td style="text-align:left;">
E
</td>
<td style="text-align:right;">
-0.87
</td>
<td style="text-align:right;">
-1.1084298
</td>
<td style="text-align:right;">
0.2384298
</td>
<td style="text-align:right;">
0.0568488
</td>
</tr>
<tr>
<td style="text-align:left;">
hothead
</td>
<td style="text-align:left;">
refuse
</td>
<td style="text-align:left;">
blind\_person
</td>
<td style="text-align:right;">
2.707174
</td>
<td style="text-align:left;">
refuse
</td>
<td style="text-align:left;">
B
</td>
<td style="text-align:left;">
P
</td>
<td style="text-align:right;">
1.28
</td>
<td style="text-align:right;">
1.0091390
</td>
<td style="text-align:right;">
0.2708610
</td>
<td style="text-align:right;">
0.0733657
</td>
</tr>
<tr>
<td style="text-align:left;">
hothead
</td>
<td style="text-align:left;">
refuse
</td>
<td style="text-align:left;">
blind\_person
</td>
<td style="text-align:right;">
2.707174
</td>
<td style="text-align:left;">
refuse
</td>
<td style="text-align:left;">
B
</td>
<td style="text-align:left;">
A
</td>
<td style="text-align:right;">
0.64
</td>
<td style="text-align:right;">
1.1709000
</td>
<td style="text-align:right;">
-0.5309000
</td>
<td style="text-align:right;">
0.2818548
</td>
</tr>
<tr>
<td style="text-align:left;">
hothead
</td>
<td style="text-align:left;">
refuse
</td>
<td style="text-align:left;">
blind\_person
</td>
<td style="text-align:right;">
2.707174
</td>
<td style="text-align:left;">
blind\_person
</td>
<td style="text-align:left;">
O
</td>
<td style="text-align:left;">
E
</td>
<td style="text-align:right;">
0.65
</td>
<td style="text-align:right;">
0.1477320
</td>
<td style="text-align:right;">
0.5022680
</td>
<td style="text-align:right;">
0.2522731
</td>
</tr>
<tr>
<td style="text-align:left;">
hothead
</td>
<td style="text-align:left;">
refuse
</td>
<td style="text-align:left;">
blind\_person
</td>
<td style="text-align:right;">
2.707174
</td>
<td style="text-align:left;">
blind\_person
</td>
<td style="text-align:left;">
O
</td>
<td style="text-align:left;">
P
</td>
<td style="text-align:right;">
-1.20
</td>
<td style="text-align:right;">
-1.5266450
</td>
<td style="text-align:right;">
0.3266450
</td>
<td style="text-align:right;">
0.1066970
</td>
</tr>
<tr>
<td style="text-align:left;">
hothead
</td>
<td style="text-align:left;">
refuse
</td>
<td style="text-align:left;">
blind\_person
</td>
<td style="text-align:right;">
2.707174
</td>
<td style="text-align:left;">
blind\_person
</td>
<td style="text-align:left;">
O
</td>
<td style="text-align:left;">
A
</td>
<td style="text-align:right;">
-1.52
</td>
<td style="text-align:right;">
-0.9211000
</td>
<td style="text-align:right;">
-0.5989000
</td>
<td style="text-align:right;">
0.3586812
</td>
</tr>
</tbody>
</table>

Following this, you can look at how different elements contribute to the
overall deflection across your events:

``` r
ggplot(data = elem_def, mapping = aes(x = sqd_diff)) + 
      geom_histogram(binwidth = 0.5) + facet_grid(dimension ~ element) + 
      theme_minimal() + labs(x = "Squared Difference between Fundamental and Transient")
```

<img src="man/figures/README-unnamed-chunk-6-1.png" width="100%" />

### Optimal Behavior

ACT can also predict the optimal behavior for the actor to enact in the
following interaction that would bring the transient sentiments back as
close as possible to the fundamental sentiments. The function
*optimal\_behavior* finds the E, P, and A value for the optimal behavior

``` r
beh <- optimal_behavior("brute", "work", "cook")
#> Warning in if (equation == "us") {: the condition has length > 1 and only the
#> first element will be used
beh
#> # A tibble: 1 x 3
#>        E     P     A
#>    <dbl> <dbl> <dbl>
#> 1 -0.110 0.763  1.61
```

### Closest Term

To find the closest measured identity, modifier, or behavior to an EPA
profile, you can use the function *closest\_term* which has 5 arguments:
the E, P, and A measurements, the type of term (identity, modifier, or
behavior, and the maximum distance away in EPA units the term can be).

``` r
closest_term(beh$E, beh$P, beh$A, term_typ = "behavior", max_dist = 1)
#> # A tibble: 10 x 5
#>    term_name   term_E term_P term_A    ssd
#>    <chr>        <dbl>  <dbl>  <dbl>  <dbl>
#>  1 haggle_with  -0.26   0.84   1.59 0.0290
#>  2 parody       -0.01   0.8    1.46 0.0347
#>  3 preach_to     0.33   1.09   1.58 0.301 
#>  4 hurry        -0.46   0.75   2.04 0.305 
#>  5 dispute      -0.1    1.32   1.54 0.315 
#>  6 dare         -0.53   0.86   1.24 0.325 
#>  7 laugh_at     -0.56   0.85   1.99 0.352 
#>  8 jest         -0.44   0.28   1.48 0.360 
#>  9 ravish        0.24   1.24   1.42 0.387 
#> 10 kid           0.22   0.36   1.25 0.403

closest_term(beh$E, beh$P, beh$A, term_typ = "behavior", max_dist = 0.5)
#> # A tibble: 10 x 5
#>    term_name   term_E term_P term_A    ssd
#>    <chr>        <dbl>  <dbl>  <dbl>  <dbl>
#>  1 haggle_with  -0.26   0.84   1.59 0.0290
#>  2 parody       -0.01   0.8    1.46 0.0347
#>  3 preach_to     0.33   1.09   1.58 0.301 
#>  4 hurry        -0.46   0.75   2.04 0.305 
#>  5 dispute      -0.1    1.32   1.54 0.315 
#>  6 dare         -0.53   0.86   1.24 0.325 
#>  7 laugh_at     -0.56   0.85   1.99 0.352 
#>  8 jest         -0.44   0.28   1.48 0.360 
#>  9 ravish        0.24   1.24   1.42 0.387 
#> 10 kid           0.22   0.36   1.25 0.403
```

### Characteristic Emotion

In ACT, there are three types of emotions: characteristic emotions,
structural emotions, and consequent emotions. Characteristic emotions
are the emotions that result from perfect confirmation of an identity -
they are the emotions that allow the transient and fundamental
impression to be equal. For example, the characteristic emotion of
“brute” is -1.40, 3.05, 1.46 - moderately bad, very powerful, and
moderately active. The closest modifier in EPA space is “domineering.”

``` r
ce <- characteristic_emotion("brute")
ce
#> [1] -1.396101  3.046890  1.459946

closest_term(ce[1], ce[2], ce[3], term_typ = "modifier", max_dist = 1)
#> # A tibble: 1 x 5
#>   term_name   term_E term_P term_A   ssd
#>   <chr>        <dbl>  <dbl>  <dbl> <dbl>
#> 1 domineering  -1.36   2.29   1.45 0.574
```

With a list of terms, you can get the EPA values for the characteristic
emotions for all of them using the function
*batch\_characteristic\_emotion*:

### Reidentification

Following an ABO event, Actors and Objects can be reidentified by the
other or an onlooker, to an identity that “fits” with their behavior
better. The functions *reidentify\_actor* and *reidentify\_object*
calculate this for you:

``` r
new_id <- events %>% 
          rowwise %>%  
          mutate(new_actor = list(reidentify_actor(actor, behavior, object, equation = "us"))) %>% 
          unnest(new_actor, names_sep = "_")

kable(new_id, digits = 2)
```

<table>
<thead>
<tr>
<th style="text-align:left;">
actor
</th>
<th style="text-align:left;">
behavior
</th>
<th style="text-align:left;">
object
</th>
<th style="text-align:right;">
d
</th>
<th style="text-align:right;">
new\_actor\_E
</th>
<th style="text-align:right;">
new\_actor\_P
</th>
<th style="text-align:right;">
new\_actor\_A
</th>
</tr>
</thead>
<tbody>
<tr>
<td style="text-align:left;">
brute
</td>
<td style="text-align:left;">
work
</td>
<td style="text-align:left;">
cook
</td>
<td style="text-align:right;">
3.91
</td>
<td style="text-align:right;">
-0.27
</td>
<td style="text-align:right;">
1.37
</td>
<td style="text-align:right;">
1.03
</td>
</tr>
<tr>
<td style="text-align:left;">
dolt
</td>
<td style="text-align:left;">
say\_farewell\_to
</td>
<td style="text-align:left;">
executioner
</td>
<td style="text-align:right;">
3.51
</td>
<td style="text-align:right;">
-0.35
</td>
<td style="text-align:right;">
0.43
</td>
<td style="text-align:right;">
-0.83
</td>
</tr>
<tr>
<td style="text-align:left;">
husband
</td>
<td style="text-align:left;">
suck\_up\_to
</td>
<td style="text-align:left;">
trainee
</td>
<td style="text-align:right;">
10.46
</td>
<td style="text-align:right;">
-1.59
</td>
<td style="text-align:right;">
-1.90
</td>
<td style="text-align:right;">
0.51
</td>
</tr>
<tr>
<td style="text-align:left;">
sheet\_metal\_worker
</td>
<td style="text-align:left;">
debate\_with
</td>
<td style="text-align:left;">
junkie
</td>
<td style="text-align:right;">
3.43
</td>
<td style="text-align:right;">
-0.01
</td>
<td style="text-align:right;">
1.40
</td>
<td style="text-align:right;">
1.51
</td>
</tr>
<tr>
<td style="text-align:left;">
hindu
</td>
<td style="text-align:left;">
beg
</td>
<td style="text-align:left;">
lout
</td>
<td style="text-align:right;">
5.02
</td>
<td style="text-align:right;">
-1.56
</td>
<td style="text-align:right;">
-3.06
</td>
<td style="text-align:right;">
0.64
</td>
</tr>
<tr>
<td style="text-align:left;">
casual\_laborer
</td>
<td style="text-align:left;">
deprecate
</td>
<td style="text-align:left;">
bailiff
</td>
<td style="text-align:right;">
7.20
</td>
<td style="text-align:right;">
-2.07
</td>
<td style="text-align:right;">
0.12
</td>
<td style="text-align:right;">
0.80
</td>
</tr>
<tr>
<td style="text-align:left;">
housebreaker
</td>
<td style="text-align:left;">
implicate
</td>
<td style="text-align:left;">
welder
</td>
<td style="text-align:right;">
2.25
</td>
<td style="text-align:right;">
-1.15
</td>
<td style="text-align:right;">
0.69
</td>
<td style="text-align:right;">
0.69
</td>
</tr>
<tr>
<td style="text-align:left;">
addict
</td>
<td style="text-align:left;">
suspect
</td>
<td style="text-align:left;">
assistant
</td>
<td style="text-align:right;">
3.94
</td>
<td style="text-align:right;">
-1.14
</td>
<td style="text-align:right;">
0.39
</td>
<td style="text-align:right;">
-0.46
</td>
</tr>
<tr>
<td style="text-align:left;">
millionaire
</td>
<td style="text-align:left;">
shock
</td>
<td style="text-align:left;">
machine\_repairer
</td>
<td style="text-align:right;">
4.07
</td>
<td style="text-align:right;">
-1.27
</td>
<td style="text-align:right;">
1.35
</td>
<td style="text-align:right;">
1.64
</td>
</tr>
<tr>
<td style="text-align:left;">
hothead
</td>
<td style="text-align:left;">
refuse
</td>
<td style="text-align:left;">
blind\_person
</td>
<td style="text-align:right;">
2.71
</td>
<td style="text-align:right;">
-1.26
</td>
<td style="text-align:right;">
1.16
</td>
<td style="text-align:right;">
0.83
</td>
</tr>
</tbody>
</table>
