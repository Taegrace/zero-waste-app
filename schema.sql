-- Users table
CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    role VARCHAR(20) NOT NULL CHECK (role IN ('donor','recipient','ngo','admin')),
    phone VARCHAR(20),
    created_at TIMESTAMPTZ DEFAULT now()
);

-- User Profiles
CREATE TABLE user_profiles (
    user_id INTEGER PRIMARY KEY REFERENCES users(id) ON DELETE CASCADE,
    address TEXT,
    city VARCHAR(100),
    pincode VARCHAR(20),
    latitude DECIMAL(9,6),
    longitude DECIMAL(9,6),
    profile_pic_url TEXT
);

-- Food Categories
CREATE TABLE categories (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50) UNIQUE NOT NULL
);

-- Donations
CREATE TABLE donations (
    id SERIAL PRIMARY KEY,
    donor_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    title VARCHAR(150) NOT NULL,
    description TEXT,
    category_id INTEGER REFERENCES categories(id),
    quantity INTEGER,
    unit VARCHAR(50),
    image_url TEXT,
    available_from TIMESTAMPTZ,
    available_until TIMESTAMPTZ,
    expiry_date DATE,
    status VARCHAR(20) NOT NULL CHECK (status IN ('available','requested','claimed','collected','cancelled')) DEFAULT 'available',
    created_at TIMESTAMPTZ DEFAULT now()
);

-- Requests
CREATE TABLE requests (
    id SERIAL PRIMARY KEY,
    donation_id INTEGER NOT NULL REFERENCES donations(id) ON DELETE CASCADE,
    requester_id INTEGER REFERENCES users(id) ON DELETE SET NULL,
    message TEXT,
    status VARCHAR(20) NOT NULL CHECK (status IN ('pending','accepted','rejected','cancelled')) DEFAULT 'pending',
    requested_at TIMESTAMPTZ DEFAULT now(),
    responded_at TIMESTAMPTZ
);

-- Pickups
CREATE TABLE pickups (
    id SERIAL PRIMARY KEY,
    donation_id INTEGER REFERENCES donations(id) ON DELETE CASCADE,
    scheduled_by INTEGER REFERENCES users(id) ON DELETE SET NULL,
    scheduled_time TIMESTAMPTZ,
    location TEXT,
    status VARCHAR(20) NOT NULL CHECK (status IN ('scheduled','completed','no_show','cancelled')) DEFAULT 'scheduled',
    created_at TIMESTAMPTZ DEFAULT now()
);

-- Notifications
CREATE TABLE notifications (
    id SERIAL PRIMARY KEY,
    user_id INTEGER REFERENCES users(id),
    type VARCHAR(50),
    payload JSONB,
    is_read BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMPTZ DEFAULT now()
);

-- Sample categories
INSERT INTO categories (name) VALUES ('Cooked Meals'), ('Vegetables'), ('Baked Goods'), ('Fruits');
