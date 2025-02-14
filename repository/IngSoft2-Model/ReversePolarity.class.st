Class {
	#name : #ReversePolarity,
	#superclass : #Permanent,
	#instVars : [
		'affectedSpaceships',
		'affectedSquare'
	],
	#category : #'IngSoft2-Model'
}

{ #category : #operations }
ReversePolarity >> applyFrom: aSpaceship target: aTarget in: gameboard [

	affectedSquare := gameboard findSquare: aTarget.
	affectedSquare togglePolarity.
]

{ #category : #removing }
ReversePolarity >> removeEffects [

	affectedSquare togglePolarity
]
