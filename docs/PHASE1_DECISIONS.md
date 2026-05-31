# Phase 1 Decisions

## Backend
**Mock services in-app** for Phase 1. Firebase planned for Phase 2.

## Chat
Text-only. Voice deferred.

## Metering
- `TimeInterval.chunkDuration = 360` seconds
- Deduction at **end** of each chunk
- `TimeInterval.gracePeriod = 30` seconds when out of tokens
- Timer **pauses** when session ends or user leaves chat

## Auth
Local anonymous UUID per install. Firebase Anonymous Auth in Phase 2.

## Wallet
Mock top-up buttons (+1, +3, +5). StoreKit in Phase 2.

## Matching
Static mock penpal list filtered by mood. Real-time queue in Phase 2.
