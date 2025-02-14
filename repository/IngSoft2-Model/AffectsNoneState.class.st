Class {
	#name : #AffectsNoneState,
	#superclass : #EffectTargetState,
	#category : #'IngSoft2-Model'
}

{ #category : #'as yet unclassified' }
AffectsNoneState >> applyEffectTo: aSquare in: aGameboard with: aSpaceship [

	"Does Nothing"
]

{ #category : #'as yet unclassified' }
AffectsNoneState >> togglePolarity [

	^ AffectsEveryoneState new.
]
