Class {
	#name : #Spaceship,
	#superclass : #Object,
	#instVars : [
		'name',
		'maxCapacity',
		'currentFuel',
		'needsToThrow',
		'lostTurns',
		'deck',
		'ally',
		'diceAdjustment',
		'currentTurbines'
	],
	#category : #'IngSoft2-Model'
}

{ #category : #initialization }
Spaceship class >> withName: aName withFuel: fuelCapacity withTurbines: turbine [

	^ self new initializeWithName: aName withFuel: fuelCapacity withTurbines: turbine 
]

{ #category : #accessing }
Spaceship >> allyWith: aSpaceship [

	ally := aSpaceship
]

{ #category : #setting }
Spaceship >> applyCard: card [

	deck appliedCard: card.
]

{ #category : #setting }
Spaceship >> applyPenaltyIn: gameboard [

	gameboard moveToStart: self.
	currentFuel := maxCapacity.
	self lostATurbine.
	lostTurns := 2
]

{ #category : #testing }
Spaceship >> canPlay [

	^ (lostTurns = 0) & (currentTurbines > 0)
]

{ #category : #setting }
Spaceship >> changeCurrentFuelBy: anAmount [

	currentFuel := currentFuel - anAmount
]

{ #category : #accessing }
Spaceship >> changeFuelCapacityBy: anAmount [

	maxCapacity := maxCapacity + anAmount.
	currentFuel := maxCapacity min: currentFuel
]

{ #category : #setting }
Spaceship >> changeTotalThrowBy: aNumber [

	diceAdjustment := diceAdjustment + aNumber.
]

{ #category : #setting }
Spaceship >> giveCard: aCard [

	deck addCard: aCard copy
]

{ #category : #initialization }
Spaceship >> initializeWithName: aName withFuel: fuelCapacity withTurbines: turbine [

	name := aName.
	currentFuel := fuelCapacity.
	maxCapacity := fuelCapacity.
	currentTurbines := turbine.
	needsToThrow := 0.
	lostTurns := 0.
	diceAdjustment := 0.
	ally := NullSpaceship new.
	deck := Deck with: #(  ) asOrderedCollection
]

{ #category : #'game logic' }
Spaceship >> lostATurbine [
	currentTurbines := currentTurbines - 1

]

{ #category : #'game logic' }
Spaceship >> lostATurn [
	lostTurns := lostTurns - 1.

]

{ #category : #accessing }
Spaceship >> move: anAmountOfSquares in: aGameboard [

	| squaresToMove |
	squaresToMove := anAmountOfSquares + diceAdjustment.

	self useAllyFuelIfNecessary: squaresToMove in: aGameboard.

	currentFuel > squaresToMove abs
		ifTrue: [
			self changeCurrentFuelBy:  squaresToMove abs.
			aGameboard move: self with: squaresToMove ]
		ifFalse: [ self applyPenaltyIn: aGameboard ]
]

{ #category : #accessing }
Spaceship >> name [ 
	^name
]

{ #category : #initialization }
Spaceship >> needsToThrow: expectedNumber [

	needsToThrow := expectedNumber.
]

{ #category : #accessing }
Spaceship >> playWith: anAmountOfSquares in: aGameboard [

	anAmountOfSquares abs < needsToThrow ifTrue: [
		self lostATurbine.
		^ self ].
	needsToThrow := 0.
	self move: anAmountOfSquares in: aGameboard
]

{ #category : #setting }
Spaceship >> refuel [

	currentFuel := maxCapacity
]

{ #category : #setting }
Spaceship >> removeEffect: cardToBeRemoved [
	^ (deck removeCardEffect: cardToBeRemoved ) 
]

{ #category : #accessing }
Spaceship >> takeFuel: anAmountOfFuel [

	anAmountOfFuel > currentFuel ifTrue: [ ^ 0 ].

	currentFuel := currentFuel - anAmountOfFuel.

	^ anAmountOfFuel
]

{ #category : #accessing }
Spaceship >> useAllyFuelIfNecessary: squaresToMove in: gameboard [

	| allyFuel |
	currentFuel <= squaresToMove abs ifFalse: [ ^ self ].

	allyFuel := ally takeFuel: squaresToMove - currentFuel + 1.

	currentFuel := currentFuel + allyFuel.

	currentFuel <= squaresToMove abs ifTrue: [
		ally applyPenaltyIn: gameboard ]
]

{ #category : #accessing }
Spaceship >> useCard: aCard [
	^ deck removeCard: aCard
	
]
