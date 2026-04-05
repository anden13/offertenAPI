/*
  Warnings:

  - You are about to drop the column `userId` on the `Offer` table. All the data in the column will be lost.
  - You are about to drop the column `name` on the `User` table. All the data in the column will be lost.
  - A unique constraint covering the columns `[offerNumber]` on the table `Offer` will be added. If there are existing duplicate values, this will fail.
  - Added the required column `companyId` to the `Offer` table without a default value. This is not possible if the table is not empty.
  - Added the required column `customerId` to the `Offer` table without a default value. This is not possible if the table is not empty.
  - Added the required column `offerNumber` to the `Offer` table without a default value. This is not possible if the table is not empty.
  - Added the required column `technicianId` to the `Offer` table without a default value. This is not possible if the table is not empty.
  - Added the required column `title` to the `Offer` table without a default value. This is not possible if the table is not empty.
  - Added the required column `updatedAt` to the `Offer` table without a default value. This is not possible if the table is not empty.
  - Added the required column `companyId` to the `User` table without a default value. This is not possible if the table is not empty.
  - Added the required column `firstName` to the `User` table without a default value. This is not possible if the table is not empty.
  - Added the required column `lastName` to the `User` table without a default value. This is not possible if the table is not empty.
  - Added the required column `updatedAt` to the `User` table without a default value. This is not possible if the table is not empty.

*/
-- CreateEnum
CREATE TYPE "UserRole" AS ENUM ('ADMIN', 'TECHNICIAN');

-- CreateEnum
CREATE TYPE "OfferStatus" AS ENUM ('DRAFT', 'SENT', 'ACCEPTED', 'REJECTED', 'EXPIRED', 'CANCELLED');

-- DropForeignKey
ALTER TABLE "Offer" DROP CONSTRAINT "Offer_userId_fkey";

-- AlterTable
ALTER TABLE "Offer" DROP COLUMN "userId",
ADD COLUMN     "acceptedAt" TIMESTAMP(3),
ADD COLUMN     "companyId" INTEGER NOT NULL,
ADD COLUMN     "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
ADD COLUMN     "currency" TEXT NOT NULL DEFAULT 'SEK',
ADD COLUMN     "customerId" INTEGER NOT NULL,
ADD COLUMN     "description" TEXT,
ADD COLUMN     "internalNotes" TEXT,
ADD COLUMN     "laborNotes" TEXT,
ADD COLUMN     "materialNotes" TEXT,
ADD COLUMN     "metadata" JSONB,
ADD COLUMN     "offerNumber" TEXT NOT NULL,
ADD COLUMN     "pdfFileName" TEXT,
ADD COLUMN     "pdfGeneratedAt" TIMESTAMP(3),
ADD COLUMN     "pdfUrl" TEXT,
ADD COLUMN     "sentAt" TIMESTAMP(3),
ADD COLUMN     "status" "OfferStatus" NOT NULL DEFAULT 'DRAFT',
ADD COLUMN     "subtotal" DECIMAL(12,2),
ADD COLUMN     "taxAmount" DECIMAL(12,2),
ADD COLUMN     "technicianId" INTEGER NOT NULL,
ADD COLUMN     "termsAndConditions" TEXT,
ADD COLUMN     "title" TEXT NOT NULL,
ADD COLUMN     "totalAmount" DECIMAL(12,2),
ADD COLUMN     "updatedAt" TIMESTAMP(3) NOT NULL,
ADD COLUMN     "validUntil" TIMESTAMP(3),
ADD COLUMN     "workScope" TEXT;

-- AlterTable
ALTER TABLE "User" DROP COLUMN "name",
ADD COLUMN     "companyId" INTEGER NOT NULL,
ADD COLUMN     "firstName" TEXT NOT NULL,
ADD COLUMN     "isActive" BOOLEAN NOT NULL DEFAULT true,
ADD COLUMN     "lastName" TEXT NOT NULL,
ADD COLUMN     "phone" TEXT,
ADD COLUMN     "role" "UserRole" NOT NULL DEFAULT 'TECHNICIAN',
ADD COLUMN     "updatedAt" TIMESTAMP(3) NOT NULL;

-- CreateTable
CREATE TABLE "Company" (
    "id" SERIAL NOT NULL,
    "name" TEXT NOT NULL,
    "logoUrl" TEXT,
    "brandColor" TEXT,
    "orgNumber" TEXT,
    "email" TEXT,
    "phone" TEXT,
    "address" TEXT,
    "city" TEXT,
    "postalCode" TEXT,
    "country" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "Company_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Customer" (
    "id" SERIAL NOT NULL,
    "companyId" INTEGER NOT NULL,
    "customerNumber" TEXT,
    "name" TEXT NOT NULL,
    "email" TEXT,
    "phone" TEXT,
    "contactPerson" TEXT,
    "address" TEXT,
    "city" TEXT,
    "postalCode" TEXT,
    "organizationNo" TEXT,
    "notes" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "Customer_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "OfferItem" (
    "id" SERIAL NOT NULL,
    "offerId" INTEGER NOT NULL,
    "sortOrder" INTEGER NOT NULL DEFAULT 0,
    "title" TEXT NOT NULL,
    "description" TEXT,
    "quantity" DECIMAL(10,2) NOT NULL,
    "unit" TEXT,
    "unitPrice" DECIMAL(12,2) NOT NULL,
    "lineTotal" DECIMAL(12,2) NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "OfferItem_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "Company_orgNumber_key" ON "Company"("orgNumber");

-- CreateIndex
CREATE INDEX "Customer_companyId_idx" ON "Customer"("companyId");

-- CreateIndex
CREATE INDEX "OfferItem_offerId_idx" ON "OfferItem"("offerId");

-- CreateIndex
CREATE UNIQUE INDEX "Offer_offerNumber_key" ON "Offer"("offerNumber");

-- CreateIndex
CREATE INDEX "Offer_companyId_idx" ON "Offer"("companyId");

-- CreateIndex
CREATE INDEX "Offer_customerId_idx" ON "Offer"("customerId");

-- CreateIndex
CREATE INDEX "Offer_technicianId_idx" ON "Offer"("technicianId");

-- CreateIndex
CREATE INDEX "User_companyId_idx" ON "User"("companyId");

-- AddForeignKey
ALTER TABLE "User" ADD CONSTRAINT "User_companyId_fkey" FOREIGN KEY ("companyId") REFERENCES "Company"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Customer" ADD CONSTRAINT "Customer_companyId_fkey" FOREIGN KEY ("companyId") REFERENCES "Company"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Offer" ADD CONSTRAINT "Offer_companyId_fkey" FOREIGN KEY ("companyId") REFERENCES "Company"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Offer" ADD CONSTRAINT "Offer_customerId_fkey" FOREIGN KEY ("customerId") REFERENCES "Customer"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Offer" ADD CONSTRAINT "Offer_technicianId_fkey" FOREIGN KEY ("technicianId") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "OfferItem" ADD CONSTRAINT "OfferItem_offerId_fkey" FOREIGN KEY ("offerId") REFERENCES "Offer"("id") ON DELETE CASCADE ON UPDATE CASCADE;
