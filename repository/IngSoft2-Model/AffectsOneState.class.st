Class {
	#name : #AffectsOneState,
	#superclass : #EffectTargetState,
	#category : #'IngSoft2-Model'
}

{ #category : #'as yet unclassified' }
AffectsOneState >> applyEffectTo: aSquare in: aGameboard with: aSpaceship [

	aSquare applyEffectToSpaceship: aSpaceship in: aGameboard
]

{ #category : #'as yet unclassified' }
AffectsOneState >> togglePolarity [

	^ AffectsAllState new.
]
