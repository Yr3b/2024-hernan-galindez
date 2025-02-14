Class {
	#name : #AtomicBomb,
	#superclass : #Square,
	#category : #'IngSoft2-Model'
}

{ #category : #'add/remove' }
AtomicBomb >> applyEffectToSpaceship: aSpaceship in: aGameboard [

	aGameboard moveToStart: aSpaceship.
]

{ #category : #initialization }
AtomicBomb >> initialize [

	super initialize.
	state := AffectsEveryoneState new.
]
