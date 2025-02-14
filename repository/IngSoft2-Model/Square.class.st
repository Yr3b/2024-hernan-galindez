Class {
	#name : #Square,
	#superclass : #Object,
	#instVars : [
		'occupiedBy',
		'gameboard',
		'state'
	],
	#category : #'IngSoft2-Model'
}

{ #category : #'instance creation' }
Square class >> create [

	^ self new initialize
]

{ #category : #'add/remove' }
Square >> applyEffectTo: aSpaceship in: aGameboard [

	state applyEffectTo: self in: aGameboard with: aSpaceship
]

{ #category : #'add/remove' }
Square >> applyEffectToSpaceship: aSpaceship in: aGameboard [

	self subclassResponsibility
]

{ #category : #accessing }
Square >> includes: aSpaceship [

	^ occupiedBy includes: aSpaceship
]

{ #category : #initialization }
Square >> initialize [

	occupiedBy := OrderedCollection new.
	state := AffectsOneState new.
]

{ #category : #'add/remove' }
Square >> keep: aSpaceship [

	occupiedBy add: aSpaceship.
]

{ #category : #'add/remove' }
Square >> leaves: aSpaceship [

	occupiedBy remove: aSpaceship
]

{ #category : #'as yet unclassified' }
Square >> togglePolarity [

	state := state togglePolarity
]
