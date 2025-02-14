Class {
	#name : #MoonWalk,
	#superclass : #Square,
	#instVars : [
		'squaresToMove',
		'board'
	],
	#category : #'IngSoft2-Model'
}

{ #category : #initialization }
MoonWalk class >> withSquaresToMove: anAmountOfSquares [ 

	^ (self new) initializeWithSquaresToMove: anAmountOfSquares .
]

{ #category : #'add/remove' }
MoonWalk >> applyEffectToSpaceship: aSpaceship in: aGameboard [

	aSpaceship move: squaresToMove negated in: aGameboard.
]

{ #category : #initialization }
MoonWalk >> initialize [
	super initialize.
	state := AffectsAllState new
]

{ #category : #initialization }
MoonWalk >> initializeWithSquaresToMove: anAmountOfSquares [

	squaresToMove := anAmountOfSquares.

]
