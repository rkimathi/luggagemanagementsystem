# Temporary Luggage Storage Database System
A Database for a Temporary Luggage Storage Management System. The system is to manage a temporary storage of luggage in Nairobi City where people with errands within town can have their luggages stored for a short duration.

luggage-storage-db/
  ├── database/
  │   └── luggage_storage.sql (your complete SQL file)
  ├── docs/
  │   └── ERD.png (or ERD.pdf)
  └── README.md

## 📖 Description
A complete MySQL database solution for temporary luggage storage services. This system manages:
- Customer information and identification
- Storage locations with capacity tracking
- Luggage items with storage/retrieval dates
- Staff assignments and management
- Payment processing
- Insurance options
- Comprehensive audit logging

## 🛠️ Database Features
- Properly normalized tables (1NF, 2NF, 3NF)
- Relationships: 1-1, 1-M, and M-M where needed
- Constraints: PK, FK, NOT NULL, UNIQUE, CHECK
- Indexes for performance optimization
- Audit trail for all data changes

## 🚀 Setup Instructions

### Prerequisites
- MySQL Server (8.0+ recommended)
- MySQL client or workbench

### Installation
1. Clone this repository:
   ```bash
   git clone https://github.com/rkimathi/luggage-storage-db.git

2. Import the database:
   mysql -u username -p < database/luggage_storage.sql
   
   Or use MySQL Workbench's import function.


