Class {
	#name : #Repeat,
	#superclass : #Instant,
	#category : #'IngSoft2-Model'
}

{ #category : #accessing }
Repeat >> applyFrom: aSpaceship target: otherSpaceshipName in: gameboard [

	| target |
	target := players detect: [ :player |
		          player name = otherSpaceshipName ].
	gameboard applyLastEffectTo: target
]
