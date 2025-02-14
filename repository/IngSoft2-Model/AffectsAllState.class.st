Class {
	#name : #AffectsAllState,
	#superclass : #EffectTargetState,
	#category : #'IngSoft2-Model'
}

{ #category : #'as yet unclassified' }
AffectsAllState >> applyEffectTo: aSquare in: aGameboard with: aSpaceship [

	| spaceshipsToAffect |
	spaceshipsToAffect := aGameboard spaceships reject: [ :s |
		                      s = aSpaceship ].
	spaceshipsToAffect do: [ :eachSpaceship |
		aSquare applyEffectToSpaceship: eachSpaceship in: aGameboard ]
]

{ #category : #'as yet unclassified' }
AffectsAllState >> togglePolarity [

	^ AffectsOneState new.
]
