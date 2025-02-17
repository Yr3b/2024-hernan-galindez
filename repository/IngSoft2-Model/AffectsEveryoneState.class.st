Class {
	#name : #AffectsEveryoneState,
	#superclass : #EffectTargetState,
	#category : #'IngSoft2-Model'
}

{ #category : #'as yet unclassified' }
AffectsEveryoneState >> applyEffectTo: aSquare in: aGameboard with: aSpaceship [

	aGameboard spaceships do: [ :eachSpaceship |
		aSquare applyEffectToSpaceship: eachSpaceship in: aGameboard ]
]

{ #category : #'as yet unclassified' }
AffectsEveryoneState >> togglePolarity [

	^ AffectsNoneState new
]
