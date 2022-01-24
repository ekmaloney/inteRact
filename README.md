
<!-- README.md is generated from README.Rmd. Please edit that file -->

# inteRact

<!-- badges: start -->
<!-- badges: end -->

The goal of inteRact is to make affect control theory (ACT) equations
accessible to a broader audience of social scientists.

ACT is a theory of social behavior that rests upon a control process in
which people act in ways that maintain cultural meaning. ACT theoretical
concepts have been fruitful when applied to research within cultural
sociology (Hunzaker 2014, 2018), stratification and occupational
prestige (Freeland and Hoey 2018), social movements (shuster and
Campos-Castillo. 2017), and gender and victimization (Boyle and McKinzie
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
implement ACT equations in your work. Because interact.jar is an
excellent Java program intended for the use of examining single events
in great detail, inteRact privileges workflows that intend to apply
Affect Control Theory equations to many events at once. Functions can
still be applied to one event, but the steps required to apply the
functions may seem onerous for only one single event.

First, for any analysis you do, you need to ensure that the identities,
behaviors, and modifiers that you study are measured in an ACT
dictionary. inteRact requires the use of an accompanying data package,
actdata, maintained by Aidan Combs and accessible here
(<https://github.com/ahcombs/actdata>). In the following analysis, I
will be using the most recent US dictionary, the US Full Surveyor
Dictionary collected in 2015.

The first step in an analysis is to create a data frame of events -
these events should follow the actor-behavior-object format of a typical
ACT interaction. This data frame can either be wide (a column each for
actor, behavior, and object), or long (multiple rows per event).

``` r
library(inteRact)
#> Loading required package: actdata
library(actdata)
library(tidyverse)
#> ── Attaching packages ─────────────────────────────────────── tidyverse 1.3.1 ──
#> ✓ ggplot2 3.3.5     ✓ purrr   0.3.4
#> ✓ tibble  3.1.6     ✓ dplyr   1.0.7
#> ✓ tidyr   1.1.4     ✓ stringr 1.4.0
#> ✓ readr   2.1.1     ✓ forcats 0.5.1
#> ── Conflicts ────────────────────────────────────────── tidyverse_conflicts() ──
#> x dplyr::filter() masks stats::filter()
#> x dplyr::lag()    masks stats::lag()

#get US 2015 dictionary using the epa subset from the actdata package
us_2015 <- epa_subset(dataset = "usfullsurveyor2015")

#make a dataframe of events 
set.seed(729)
events_wide <- tibble(actor = sample(us_2015$term[us_2015$component == "identity"], 10),
                 behavior = sample(us_2015$term[us_2015$component == "behavior"], 10),
                 object = sample(us_2015$term[us_2015$component == "identity"], 10))

set.seed(729)
events_long <- tibble(id = rep(1:10, 3),
                      term = c(sample(us_2015$term[us_2015$component == "identity"], 10),
                               sample(us_2015$term[us_2015$component == "behavior"], 10),
                               sample(us_2015$term[us_2015$component == "identity"], 10)),
                      element = rep(c("actor", "behavior", "object"), each = 10)) %>% 
                arrange(id)

head(events_wide)
#> # A tibble: 6 × 3
#>   actor          behavior        object      
#>   <chr>          <chr>           <chr>       
#> 1 authority      hide_from       student     
#> 2 mormon         dine_with       underdog    
#> 3 alcoholic      fondle          peer        
#> 4 civil_engineer fire_from_a_job ticket_taker
#> 5 brain          boss            negotiator  
#> 6 bookkeeper     rebel_against   black
head(events_long)
#> # A tibble: 6 × 3
#>      id term      element 
#>   <int> <chr>     <chr>   
#> 1     1 authority actor   
#> 2     1 hide_from behavior
#> 3     1 student   object  
#> 4     2 mormon    actor   
#> 5     2 dine_with behavior
#> 6     2 underdog  object
```

The next step is to augment your events with the corresponding EPA
measures from the ACT dictionary. To do this, you should use the
reshape\_events\_df on your events dataframe. You must indicate the
dictionary you are using by its actdata key (in this case
“usfullsurveyor2015”) and the gender of those dictionary estimates (here
I am using the average of the male and female estimates). This function
has an indicator whether your events dataframe is wide or long - if it
is long, you must use the id\_column argument to indicate the variable
that you are using to group the events by.

``` r
analysis_df <- reshape_events_df(df = events_wide,
                                 df_format = "wide",
                                 dictionary_key = "usfullsurveyor2015",
                                 dictionary_gender = "average")
#> Joining, by = c("term", "component")

head(analysis_df)
#> # A tibble: 6 × 6
#>   event_id element  term      component dimension estimate
#>      <int> <chr>    <chr>     <chr>     <chr>        <dbl>
#> 1        1 actor    authority identity  E             0.7 
#> 2        1 actor    authority identity  P             2.99
#> 3        1 actor    authority identity  A             0.85
#> 4        1 behavior hide_from behavior  E            -0.82
#> 5        1 behavior hide_from behavior  P            -0.86
#> 6        1 behavior hide_from behavior  A            -1.37

analysis_df <- reshape_events_df(df = events_long,
                                 df_format = "long",
                                 id_column = "id",
                                 dictionary_key = "usfullsurveyor2015",
                                 dictionary_gender = "average")
#> Joining, by = c("term", "component")

head(analysis_df)
#> # A tibble: 6 × 6
#>   term      element  component event_id dimension estimate
#>   <chr>     <chr>    <chr>        <int> <chr>        <dbl>
#> 1 authority actor    identity         1 E             0.7 
#> 2 authority actor    identity         1 P             2.99
#> 3 authority actor    identity         1 A             0.85
#> 4 hide_from behavior behavior         1 E            -0.82
#> 5 hide_from behavior behavior         1 P            -0.86
#> 6 hide_from behavior behavior         1 A            -1.37
```

After reshaping your events, you now have a dataframe with the
*fundamental sentiments* of each element of your Actor-Behavior-Object
events. In ACT, fundamental sentiments are the stable cultural meaning
of a social identity, behavior, or emotion. These sentiments fall along
3 dimensions: Evaluation, how good or bad the concept is, Potency, how
powerful or weak, and Activity, how fast/young or slow/old. Values of
these dimensions range from -4.3 (extremely bad, weak, slow) to 4.3
(extremely good, powerful, active).

Once you have the overall analysis dataframe, you should group\_by the
event\_id and nest the rest of the data, this will allow you to apply
the main ACT functions to each event in the dataframe. Next, you should
add a column indicating the equation you will be using to analyze the
events. This should take the form "{equation\_key}\_{gender}" from the
actdata package. In the following code, you will see that I am using the
us2010 equation averaged across genders to match the dictionary.

``` r
nested_analysis_df <- analysis_df %>% 
                      group_by(event_id) %>% 
                      nest() %>% 
                      mutate(eq_info = "us2010_average")
```

Now, you can apply various functions to each event by using the map2()
function from the purrr package. For example, to get the deflection of
each event, you use the map2 function to iteratively apply the
get\_deflection function to each dataframe of events and equation
information inside the nested dataframe.

``` r
results_df <- nested_analysis_df %>% 
              mutate(deflection = map2(data, eq_info, get_deflection))

results_df %>% unnest() %>% select(event_id, term, deflection) %>% distinct()
#> Warning: `cols` is now required when using unnest().
#> Please use `cols = c(data, deflection)`
#> # A tibble: 30 × 3
#> # Groups:   event_id [10]
#>    event_id term           deflection
#>       <int> <chr>               <dbl>
#>  1        1 authority           13.3 
#>  2        1 hide_from           13.3 
#>  3        1 student             13.3 
#>  4        2 mormon               5.06
#>  5        2 dine_with            5.06
#>  6        2 underdog             5.06
#>  7        3 alcoholic            9.00
#>  8        3 fondle               9.00
#>  9        3 peer                 9.00
#> 10        4 civil_engineer      13.0 
#> # … with 20 more rows
```

### Deflection

When applying Affect Control Theory in research contexts, one of the
most typical questions is - what is the deflection of this event? The
*deflection* is an indicator of how culturally unlikely an event is to
occur - a higher deflection indicates a more unexpected event. ACT
calculates how much each element (Actor, Behavior, Object) moves along
each dimension (Evaluation, Potency, Activity) after an event - these
new locations in EPA space are termed the *transient impressions*. The
deflection is the sum of squared differences between the fundamental
sentiments and transient impressions for each element of the event.

You can replicate the results from the get\_deflection function by
calculating the transient impression of each event, calculating the
squared differences between fundamental sentiments and transient
impressions, squaring them, and then summing those squared differences.

``` r
nested_analysis_df %>% 
    mutate(trans_imp = map2(data, eq_info, transient_impression)) %>% 
    unnest(trans_imp) %>% 
    mutate(difference = estimate - trans_imp,
           sqd_difference = difference^2) %>% 
    group_by(event_id) %>% 
    summarise(deflection = sum(sqd_difference))
#> # A tibble: 10 × 2
#>    event_id deflection
#>       <int>      <dbl>
#>  1        1      13.3 
#>  2        2       5.06
#>  3        3       9.00
#>  4        4      13.0 
#>  5        5      37.1 
#>  6        6      13.2 
#>  7        7      12.4 
#>  8        8      23.7 
#>  9        9       2.51
#> 10       10       2.43
```

### Element Deflection

You may even be particularly interested in which element-dimensions move
the most in EPA space from your events.

``` r
nested_analysis_df %>% 
    mutate(elem_def = map2(data, eq_info, element_deflection)) %>% 
    unnest(elem_def) %>% ggplot(mapping = aes(x = sqd_diff)) + 
      geom_histogram(binwidth = 0.5) + facet_grid(dimension ~ element) + 
      theme_minimal() + labs(x = "Squared Difference between Fundamental and Transient")
```

<img src="man/figures/README-unnamed-chunk-7-1.png" width="100%" />

### Optimal Behavior

ACT can also predict the optimal behavior for the actor to enact in the
following interaction that would bring the transient sentiments back as
close as possible to the fundamental sentiments. The function
*optimal\_behavior* finds the E, P, and A value for the optimal behavior

``` r
nested_analysis_df %>% 
  mutate(opt_beh = map2(data, eq_info, optimal_behavior)) %>% 
  unnest(opt_beh)
#> # A tibble: 20 × 7
#> # Groups:   event_id [10]
#>    event_id data             eq_info          opt_E   opt_P  opt_A term  
#>       <int> <list>           <chr>            <dbl>   <dbl>  <dbl> <chr> 
#>  1        1 <tibble [9 × 5]> us2010_average  1.48    1.88    1.64  actor 
#>  2        1 <tibble [9 × 5]> us2010_average  1.76   -0.0444  0.593 object
#>  3        2 <tibble [9 × 5]> us2010_average -0.112   0.510  -0.483 actor 
#>  4        2 <tibble [9 × 5]> us2010_average -0.135   0.0444 -0.251 object
#>  5        3 <tibble [9 × 5]> us2010_average -0.491  -1.67    1.17  actor 
#>  6        3 <tibble [9 × 5]> us2010_average  0.799   1.43    0.947 object
#>  7        4 <tibble [9 × 5]> us2010_average  2.08    1.13    0.387 actor 
#>  8        4 <tibble [9 × 5]> us2010_average  0.271   0.462   0.628 object
#>  9        5 <tibble [9 × 5]> us2010_average  4.10    2.11    2.65  actor 
#> 10        5 <tibble [9 × 5]> us2010_average  3.02    1.78    1.90  object
#> 11        6 <tibble [9 × 5]> us2010_average  1.97   -0.175  -1.39  actor 
#> 12        6 <tibble [9 × 5]> us2010_average  0.0478  1.79    0.322 object
#> 13        7 <tibble [9 × 5]> us2010_average  0.0677  0.0705 -0.454 actor 
#> 14        7 <tibble [9 × 5]> us2010_average -1.28   -0.507   0.736 object
#> 15        8 <tibble [9 × 5]> us2010_average  2.30    1.20    0.236 actor 
#> 16        8 <tibble [9 × 5]> us2010_average  0.846   0.955   3.08  object
#> 17        9 <tibble [9 × 5]> us2010_average  0.998   1.16    1.24  actor 
#> 18        9 <tibble [9 × 5]> us2010_average  0.868   0.308   1.27  object
#> 19       10 <tibble [9 × 5]> us2010_average  1.13    0.528   0.378 actor 
#> 20       10 <tibble [9 × 5]> us2010_average  0.661   0.894   0.716 object
```

### Actor and Object Reidentification

Following an ABO event, Actors and Objects can be reidentified by the
other or an onlooker, to an identity that “fits” with their behavior
better. The functions *reidentify\_actor* and *reidentify\_object*
calculate this for you:

``` r
nested_analysis_df %>% 
  mutate(new_actor_id = map2(data, eq_info, reidentify_actor),
         new_object_id = map2(data, eq_info, reidentify_object)) %>% 
  unnest(new_actor_id)
#> # A tibble: 10 × 7
#> # Groups:   event_id [10]
#>    event_id data             eq_info              E      P      A new_object_id 
#>       <int> <list>           <chr>            <dbl>  <dbl>  <dbl> <list>        
#>  1        1 <tibble [9 × 5]> us2010_average -1.40   -1.07  -1.53  <tibble [1 × …
#>  2        2 <tibble [9 × 5]> us2010_average -0.0157  0.919 -0.313 <tibble [1 × …
#>  3        3 <tibble [9 × 5]> us2010_average  0.126   0.710 -0.169 <tibble [1 × …
#>  4        4 <tibble [9 × 5]> us2010_average -2.72    2.15   1.33  <tibble [1 × …
#>  5        5 <tibble [9 × 5]> us2010_average -2.99    1.62   2.12  <tibble [1 × …
#>  6        6 <tibble [9 × 5]> us2010_average  0.0895  1.75   2.13  <tibble [1 × …
#>  7        7 <tibble [9 × 5]> us2010_average -0.0565  2.73   1.58  <tibble [1 × …
#>  8        8 <tibble [9 × 5]> us2010_average -3.57    1.73   3.15  <tibble [1 × …
#>  9        9 <tibble [9 × 5]> us2010_average  1.33    0.803 -0.694 <tibble [1 × …
#> 10       10 <tibble [9 × 5]> us2010_average  1.78    1.66  -0.394 <tibble [1 × …
```

### Closest Term

To find the closest measured identity, modifier, or behavior to an EPA
profile, you can use the function *closest\_term* which has 5 arguments:
the E, P, and A measurements, the type of term (identity, modifier, or
behavior, and the maximum distance away in EPA units the term can be).

``` r
nested_analysis_df %>% 
  mutate(new_actor_id = map2(data, eq_info, reidentify_actor),
         new_object_id = map2(data, eq_info, reidentify_object)) %>% 
  unnest(new_actor_id) %>% 
  rowwise() %>% 
  mutate(term = closest_term(E, P, A, dictionary_key = "usfullsurveyor2015", gender = "average",
               term_typ = "identity", num_terms = 1)) %>% 
  unnest(cols = c(term))
#> # A tibble: 10 × 12
#> # Groups:   event_id [10]
#>    event_id data   eq_info        E      P      A new_object_id term_name term_E
#>       <int> <list> <chr>      <dbl>  <dbl>  <dbl> <list>        <chr>      <dbl>
#>  1        1 <tibb… us2010_… -1.40   -1.07  -1.53  <tibble [1 ×… miser      -1.61
#>  2        2 <tibb… us2010_… -0.0157  0.919 -0.313 <tibble [1 ×… imam        0.17
#>  3        3 <tibb… us2010_…  0.126   0.710 -0.169 <tibble [1 ×… conserva…   0.44
#>  4        4 <tibb… us2010_… -2.72    2.15   1.33  <tibble [1 ×… gunman     -2.33
#>  5        5 <tibb… us2010_… -2.99    1.62   2.12  <tibble [1 ×… slave_dr…  -3.28
#>  6        6 <tibb… us2010_…  0.0895  1.75   2.13  <tibble [1 ×… jock        0.34
#>  7        7 <tibb… us2010_… -0.0565  2.73   1.58  <tibble [1 ×… prosecut…   0.15
#>  8        8 <tibb… us2010_… -3.57    1.73   3.15  <tibble [1 ×… No terms…  NA   
#>  9        9 <tibb… us2010_…  1.33    0.803 -0.694 <tibble [1 ×… bank_tel…   1.27
#> 10       10 <tibb… us2010_…  1.78    1.66  -0.394 <tibble [1 ×… scientist   1.89
#> # … with 3 more variables: term_P <dbl>, term_A <dbl>, ssd <dbl>
```
