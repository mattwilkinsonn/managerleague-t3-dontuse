-- CreateEnum
CREATE TYPE "UserRole" AS ENUM ('ADMIN', 'USER');

-- CreateEnum
CREATE TYPE "Position" AS ENUM ('GK', 'DL', 'DC', 'DR', 'WBL', 'WBR', 'DM', 'ML', 'MC', 'MR', 'AML', 'AMC', 'AMR', 'LF', 'ST', 'RF');

-- CreateEnum
CREATE TYPE "Role" AS ENUM ('GOALKEEPER', 'FULLBACK', 'CENTER_BACK', 'WING_BACK', 'DEFENSIVE_MIDFIELDER', 'CENTRAL_MIDFIELDER', 'WINGER', 'ATTACKING_MIDFIELDER', 'STRIKER');

-- CreateEnum
CREATE TYPE "UserSetupStatus" AS ENUM ('CREATE_CLUB', 'DRAFT_PLAYERS', 'DONE');

-- CreateTable
CREATE TABLE "Account" (
    "id" UUID NOT NULL,
    "userId" UUID NOT NULL,
    "type" TEXT NOT NULL,
    "provider" TEXT NOT NULL,
    "providerAccountId" TEXT NOT NULL,
    "refresh_token" TEXT,
    "access_token" TEXT,
    "expires_at" INTEGER,
    "token_type" TEXT,
    "scope" TEXT,
    "id_token" TEXT,
    "session_state" TEXT,

    CONSTRAINT "Account_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Session" (
    "id" UUID NOT NULL,
    "sessionToken" TEXT NOT NULL,
    "userId" UUID NOT NULL,
    "expires" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "Session_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "User" (
    "id" UUID NOT NULL,
    "name" TEXT,
    "email" TEXT,
    "emailVerified" TIMESTAMP(3),
    "image" TEXT,
    "setupStatus" "UserSetupStatus" NOT NULL DEFAULT 'CREATE_CLUB',
    "role" "UserRole" NOT NULL DEFAULT 'USER',

    CONSTRAINT "User_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "VerificationToken" (
    "identifier" TEXT NOT NULL,
    "token" TEXT NOT NULL,
    "expires" TIMESTAMP(3) NOT NULL
);

-- CreateTable
CREATE TABLE "Club" (
    "id" UUID NOT NULL,
    "name" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "userId" UUID NOT NULL,

    CONSTRAINT "Club_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "PlayerClub" (
    "id" UUID NOT NULL,
    "playerId" UUID NOT NULL,
    "clubId" UUID NOT NULL,
    "joinedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "leftAt" TIMESTAMP(3),

    CONSTRAINT "PlayerClub_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "PlayerPositionRole" (
    "id" UUID NOT NULL,
    "playerId" UUID NOT NULL,
    "position" "Position" NOT NULL,
    "role" "Role" NOT NULL,
    "rating" INTEGER NOT NULL DEFAULT 0,

    CONSTRAINT "PlayerPositionRole_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Player" (
    "id" UUID NOT NULL,
    "firstName" TEXT NOT NULL,
    "lastName" TEXT NOT NULL,
    "birthSeasonId" INTEGER NOT NULL,
    "ability" INTEGER NOT NULL DEFAULT 0,
    "aerialAbility" INTEGER NOT NULL DEFAULT 0,
    "commandOfArea" INTEGER NOT NULL DEFAULT 0,
    "communication" INTEGER NOT NULL DEFAULT 0,
    "eccentricity" INTEGER NOT NULL DEFAULT 0,
    "handling" INTEGER NOT NULL DEFAULT 0,
    "kicking" INTEGER NOT NULL DEFAULT 0,
    "oneOnOnes" INTEGER NOT NULL DEFAULT 0,
    "reflexes" INTEGER NOT NULL DEFAULT 0,
    "rushingOut" INTEGER NOT NULL DEFAULT 0,
    "tendencyToPunch" INTEGER NOT NULL DEFAULT 0,
    "throwing" INTEGER NOT NULL DEFAULT 0,
    "corners" INTEGER NOT NULL DEFAULT 0,
    "crossing" INTEGER NOT NULL DEFAULT 0,
    "dribbling" INTEGER NOT NULL DEFAULT 0,
    "finishing" INTEGER NOT NULL DEFAULT 0,
    "firstTouch" INTEGER NOT NULL DEFAULT 0,
    "freeKicks" INTEGER NOT NULL DEFAULT 0,
    "heading" INTEGER NOT NULL DEFAULT 0,
    "longShots" INTEGER NOT NULL DEFAULT 0,
    "longThrows" INTEGER NOT NULL DEFAULT 0,
    "marking" INTEGER NOT NULL DEFAULT 0,
    "passing" INTEGER NOT NULL DEFAULT 0,
    "penaltyTaking" INTEGER NOT NULL DEFAULT 0,
    "tackling" INTEGER NOT NULL DEFAULT 0,
    "technique" INTEGER NOT NULL DEFAULT 0,
    "aggression" INTEGER NOT NULL DEFAULT 0,
    "anticipation" INTEGER NOT NULL DEFAULT 0,
    "bravery" INTEGER NOT NULL DEFAULT 0,
    "composure" INTEGER NOT NULL DEFAULT 0,
    "concentration" INTEGER NOT NULL DEFAULT 0,
    "decisions" INTEGER NOT NULL DEFAULT 0,
    "determination" INTEGER NOT NULL DEFAULT 0,
    "flair" INTEGER NOT NULL DEFAULT 0,
    "leadership" INTEGER NOT NULL DEFAULT 0,
    "offTheBall" INTEGER NOT NULL DEFAULT 0,
    "positioning" INTEGER NOT NULL DEFAULT 0,
    "teamwork" INTEGER NOT NULL DEFAULT 0,
    "vision" INTEGER NOT NULL DEFAULT 0,
    "workRate" INTEGER NOT NULL DEFAULT 0,
    "acceleration" INTEGER NOT NULL DEFAULT 0,
    "agility" INTEGER NOT NULL DEFAULT 0,
    "balance" INTEGER NOT NULL DEFAULT 0,
    "jumping" INTEGER NOT NULL DEFAULT 0,
    "naturalFitness" INTEGER NOT NULL DEFAULT 0,
    "pace" INTEGER NOT NULL DEFAULT 0,
    "stamina" INTEGER NOT NULL DEFAULT 0,
    "strength" INTEGER NOT NULL DEFAULT 0,

    CONSTRAINT "Player_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Season" (
    "id" SERIAL NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "startDate" TIMESTAMP(3) NOT NULL,
    "endDate" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "Season_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "Account_provider_providerAccountId_key" ON "Account"("provider", "providerAccountId");

-- CreateIndex
CREATE UNIQUE INDEX "Session_sessionToken_key" ON "Session"("sessionToken");

-- CreateIndex
CREATE UNIQUE INDEX "User_email_key" ON "User"("email");

-- CreateIndex
CREATE UNIQUE INDEX "VerificationToken_token_key" ON "VerificationToken"("token");

-- CreateIndex
CREATE UNIQUE INDEX "VerificationToken_identifier_token_key" ON "VerificationToken"("identifier", "token");

-- CreateIndex
CREATE UNIQUE INDEX "Club_name_key" ON "Club"("name");

-- AddForeignKey
ALTER TABLE "Account" ADD CONSTRAINT "Account_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Session" ADD CONSTRAINT "Session_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Club" ADD CONSTRAINT "Club_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "PlayerClub" ADD CONSTRAINT "PlayerClub_playerId_fkey" FOREIGN KEY ("playerId") REFERENCES "Player"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "PlayerClub" ADD CONSTRAINT "PlayerClub_clubId_fkey" FOREIGN KEY ("clubId") REFERENCES "Club"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "PlayerPositionRole" ADD CONSTRAINT "PlayerPositionRole_playerId_fkey" FOREIGN KEY ("playerId") REFERENCES "Player"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Player" ADD CONSTRAINT "Player_birthSeasonId_fkey" FOREIGN KEY ("birthSeasonId") REFERENCES "Season"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
