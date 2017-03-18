# No More GATCHA - Demonstrating how dangerous picking random boxes are

GATCHAs are a slang in South Korea, meaning random boxes which give players a random item. 

This project aims to simulate how many times in average do we need to pick a random box to collect all the items.

More precisely, suppose we want to collect N items which are to be only gained by picking a random box. 
If the probability of the items to appear are equal, then we can find that we have to pick N*log(N) times to collect all the items in average.

You can download, and test GATCHAs with any probability distribution you want. The project code is written in Swift.

## Installation

Clone, download, or copy-and-paste the code, and compile it.

## Visualization

The simulation code is written in Swift, but the project also supports visualization script written in R. The script has a dependency to ```dplyr``` and ```ggplot2```.