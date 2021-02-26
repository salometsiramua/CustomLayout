# CustomLayout

Wrote an algorithm translating json data to UI components.

Creating connected objects array as Constraint, extracting width values of objects that have fixed width and calculating the remaining items width by dividing remaining width to the count of remaining items, to equaly distribute them.

Calculating X position of the object after we know all the width of the items. (By calculating accumulatedX)

For text and date components calculating height of the view according to the size to fit. (Having passed the width of the object)
Could not count height for image.

Unit tests added to the project.

Drawing one sample of json.
