#include <iostream>
#include <vector>
#include <algorithm>

int main()
{
    std::vector<int> v = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20};

    // Filter: Get all even numbers
    std::vector<int> evens;
    std::copy_if(v.begin(), v.end(), std::back_inserter(evens), [](int i)
                 { return i % 2 == 0; });

    // Transform: Square each even number
    std::vector<int> squares;
    std::transform(evens.begin(), evens.end(), std::back_inserter(squares), [](int i)
                   { return i * i; });

    // Print the results
    std::cout << "Squared even numbers: ";
    for (int i : squares)
    {
        std::cout << i << " ";
    }
    std::cout << std::endl;

    return 0;
}