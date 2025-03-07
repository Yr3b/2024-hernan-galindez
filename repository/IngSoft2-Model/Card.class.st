Class {
	#name : #Card,
	#superclass : #Object,
	#instVars : [
		'name',
		'players'
	],
	#category : #'IngSoft2-Model'
}

{ #category : #operations }
Card class >> createWith: players [

	^ self new initializeWith: players
]

{ #category : #comparing }
Card >> = anotherCard [

	^(anotherCard isKindOf: self class)
]

{ #category : #operations }
Card >> applyFrom: aSpaceship target: aTarget in: gameboard [

	self subclassResponsibility.
]

{ #category : #initialization }
Card >> initializeWith: playersCollection [
	players := playersCollection
]

{ #category : #operations }
Card >> verifyCanBePlayed: isShipTurn [

	self subclassResponsibility
]
