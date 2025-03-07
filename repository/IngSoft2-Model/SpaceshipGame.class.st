Class {
	#name : #SpaceshipGame,
	#superclass : #Object,
	#instVars : [
		'players',
		'gameboard',
		'dice',
		'numberOfLaps',
		'rewards',
		'possibleCards',
		'redoCardInstance'
	],
	#category : #'IngSoft2-Model'
}

{ #category : #'instance creation' }
SpaceshipGame class >> withPlayers: somePlayers withTurbines: turbine withGameboardLength: aLength withDice: aDiceCollection withLaps: anAmountOfLaps withParsecs: aNumberOfParsecs [

	^ self new
		  initializeWithPlayers: somePlayers
		  withTurbines: turbine
		  withGameboardLength: aLength
		  withDice: aDiceCollection
		  withLaps: anAmountOfLaps
		  withParsecs: aNumberOfParsecs
]

{ #category : #'instance creation' }
SpaceshipGame class >> withPlayers: somePlayers withTurbines: turbine withGameboardLength: aLength withDice: aDiceCollection withLaps: anAmountOfLaps withParsecs: aNumberOfParsecs squareGenerator: sqaureGenerator rewards: rewards cards: deckOfCards [

	^ self new
		  initializeWithPlayers: somePlayers
		  withTurbines: turbine
		  withGameboardLength: aLength
		  withDice: aDiceCollection
		  withLaps: anAmountOfLaps
		  withParsecs: aNumberOfParsecs
		  withSquareGenerator: sqaureGenerator
		  withRewards: rewards
		  withCards: deckOfCards
]

{ #category : #initialization }
SpaceshipGame >> initializeWithPlayers: aCollectionOfPlayers withTurbines: turbine withGameboardLength: aLength withDice: aDiceCollection withLaps: anAmountOfLaps withParsecs: aNumberOfParsecs [

	| squareGenerator cardCollection |
	dice := Dice with: aDiceCollection.

	squareGenerator := DefaultSquareGenerator distributions: {
			                   ([ NormalSquare create ] -> (3 / 10)).
			                   ([
			                    HyperGravity withExpectedNumber:
				                    dice maxThrow atRandom ] -> (2 / 10)).
			                   ([ AtomicBomb create ] -> (2 / 100)).
			                   ([ BlackHole create ] -> (2 / 10)).
			                   ([
			                    MoonWalk withSquaresToMove:
				                    dice maxThrow atRandom ] -> (1 / 10)).
			                   ([ HyperJump with: { (Parsecs of: 100) } ]
			                    -> (8 / 100)).
			                   ([ CardSquare create ] -> (1 / 10)) }.

	rewards := RewardsManager with: {
			           ((DecrementCurrentFuel by: 1) -> 0.2).
			           ((IncrementFuelCapacity by: 1) -> 0.8) }.

	cardCollection := {
		                  Cancellation.
		                  Repeat.
		                  Acceleration.
		                  Ally.
		                  Overload.
		                  Redo }.

	redoCardInstance := Redo recreate.

	players := aCollectionOfPlayers collect: [ :playerName |
		           Spaceship
			           withName: playerName
			           withFuel: dice maxThrow * 2
			           withTurbines: turbine ].

	possibleCards := (cardCollection collect: [ :cardClass |
		                  cardClass createWith: players ])
		                 asOrderedCollection.
	players do: [ :player |
		player
			giveCard: possibleCards atRandom;
			giveCard: possibleCards atRandom ].

	Redo deleteInstance.

	gameboard := Gameboard
		             numberOfSquares: aLength
		             spaceships: players
		             withParsecs: aNumberOfParsecs
		             using: dice
		             generator: squareGenerator
		             cards: possibleCards.

	numberOfLaps := anAmountOfLaps
]

{ #category : #initialization }
SpaceshipGame >> initializeWithPlayers: aCollectionOfPlayers withTurbines: turbine withGameboardLength: aLength withDice: aDiceCollection withLaps: anAmountOfLaps withParsecs: aNumberOfParsecs withSquareGenerator: squareGenerator withRewards: aReward withCards: cardCollection [ 

	dice := Dice with: aDiceCollection.


	players := aCollectionOfPlayers collect: [ :playerName |
		           Spaceship
			           withName: playerName
			           withFuel: dice maxThrow * 2
			           withTurbines: turbine ].
	redoCardInstance := Redo recreate.
	possibleCards := (cardCollection collect: [ :cardClass |
		                  cardClass createWith: players ])
		                 asOrderedCollection.

	players do: [ :player |
		player
			giveCard: possibleCards first;
			giveCard: possibleCards second ].

	Redo deleteInstance.
	gameboard := Gameboard
		             numberOfSquares: aLength
		             spaceships: players
		             withParsecs: aNumberOfParsecs
		             using: dice
		             generator: squareGenerator
		             cards:
		             (possibleCards copyFrom: 3 to: possibleCards size).
	numberOfLaps := anAmountOfLaps.

	rewards := aReward
]

{ #category : #'game logic' }
SpaceshipGame >> isOver [

	^ players anySatisfy: [ :aSpaceship |
		  (gameboard lapsCompletedOf: aSpaceship) >= numberOfLaps ]
]

{ #category : #accessing }
SpaceshipGame >> lapsCompletedOf: aSpaceshipName [

	| aSpaceship |
	aSpaceship := players detect: [ :player |
		              player name = aSpaceshipName ].


	^ gameboard lapsCompletedOf: aSpaceship
]

{ #category : #'game logic' }
SpaceshipGame >> nextPlayer [

	| currentPlayer |
	currentPlayer := players removeFirst.
	players addLast: currentPlayer.



	[ currentPlayer canPlay ] whileFalse: [
		currentPlayer lostATurn.
		currentPlayer := players removeFirst.
		players addLast: currentPlayer ].

	^ currentPlayer
]

{ #category : #'game controls' }
SpaceshipGame >> playCard: card from: spaceshipName target: target [

	| spaceshipToPlay spaceship cardToBeUsed |
	self verifyGameIsNotOver.

	spaceshipToPlay := players detect: [ :player | player canPlay ].
	spaceship := players detect: [ :player | player name = spaceshipName ].

	cardToBeUsed := spaceship useCard: card.
	cardToBeUsed verifyCanBePlayed: spaceshipToPlay = spaceship.

	cardToBeUsed
		applyFrom: spaceship
		target: target
		in: gameboard.
	redoCardInstance lastUsedCard: cardToBeUsed
]

{ #category : #'game controls' }
SpaceshipGame >> playTurn [

	| aNumber spaceshipToPlay |
	self verifyGameIsNotOver.
	spaceshipToPlay := self nextPlayer.
	aNumber := dice throw.
	aNumber = dice maxThrow ifTrue: [ rewards applyTo: spaceshipToPlay ].
	spaceshipToPlay playWith: aNumber in: gameboard.
	gameboard applyEffectTo: spaceshipToPlay.
	
]

{ #category : #'game logic' }
SpaceshipGame >> positionOf: aSpaceshipName [

	| aSpaceship |
	aSpaceship := players detect: [ :player |
		              player name = aSpaceshipName ].
	^ gameboard find: aSpaceship
]

{ #category : #'game logic' }
SpaceshipGame >> rankings [

	| comparisonBlock sortedCollection playerPosition playerLap playerPositionArray |
	self isOver ifFalse: [ Error signal: 'Game is not over' ].

	comparisonBlock := [ :a :b | a second >= b second ].

	sortedCollection := SortedCollection sortBlock: comparisonBlock.

	players do: [ :player |
		playerPosition := gameboard find: player.
		playerLap := gameboard lapsCompletedOf: player.
		playerPositionArray := OrderedCollection
			                       with: player
			                       with: playerLap @ playerPosition.
		sortedCollection add: playerPositionArray ].


	^ sortedCollection collect: [ :position | position first name ]
]

{ #category : #'game logic' }
SpaceshipGame >> skipTurn [

	| currentPlayer |
	currentPlayer := self nextPlayer.
	currentPlayer refuel
]

{ #category : #'game logic' }
SpaceshipGame >> verifyGameIsNotOver [

	self isOver ifTrue: [ Error signal: 'Game is over' ]
]

{ #category : #'game logic' }
SpaceshipGame >> winner [

	| raceWinner |
	raceWinner := players
		              detect: [ :player |
		              (gameboard lapsCompletedOf: player) >= numberOfLaps ]
		              ifNone: [ Error signal: 'There is no winner yet' ].
	^ raceWinner name
]
