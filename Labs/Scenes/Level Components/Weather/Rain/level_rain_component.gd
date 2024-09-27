class_name RainComponent extends Node2D
## Manages rain areas.

## Every rain component will manage rain areas. If this component exists in the scene, it means
## there has to be at least one rain area present, this is why it comes with one already; however,
## more can be added, with different sizes and timings, helpful for magic spells and more.


# todo
# register rain areas? Can have 0? Deprecate the one that comes by default?
# when to disable them? based or told by who? Weather component? Level information?
# rain_chance %
# what does rain_chance 5% mean for example? what is 100%? a full day? NNN ticks/seconds?
