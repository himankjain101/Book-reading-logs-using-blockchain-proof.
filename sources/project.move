module MyModule::BookReadingLogs {

    use aptos_framework::signer;
    use std::string;
    use std::vector;

    /// Struct to store reading logs.
    struct ReadingLog has store, key {
        logs: vector<string::String>, // Stores the list of books read
    }

    /// Function to log a book as read.
    public fun log_reading(user: &signer, book_name: string::String) acquires ReadingLog {
        let addr = signer::address_of(user);

        // If ReadingLog does not exist, initialize it
        if (!exists<ReadingLog>(addr)) {
            move_to(user, ReadingLog { logs: vector::empty<string::String>() });
            return; // Exit to prevent borrowing in the same function execution
        };

        // Borrow and update the ReadingLog
        borrow_global_mut<ReadingLog>(addr).logs.push_back(book_name);
    }

    /// Function to retrieve a user's reading log.
    public fun get_log(user: address): vector<string::String> acquires ReadingLog {
        if (!exists<ReadingLog>(user)) {
            return vector::empty<string::String>();
        };
        borrow_global<ReadingLog>(user).logs
    }
}
