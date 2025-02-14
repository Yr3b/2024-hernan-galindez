Class {
	#name : #EffectTargetState,
	#superclass : #Object,
	#category : #'IngSoft2-Model'
}

{ #category : #'as yet unclassified' }
EffectTargetState >> applyEffectTo: aSquare in: aGameboard with: aSpaceship [

	self subclassResponsibility
]

{ #category : #'as yet unclassified' }
EffectTargetState >> togglePolarity [

	self subclassResponsibility
]
