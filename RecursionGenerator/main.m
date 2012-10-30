//
//  main.m
//  Recursion Generator
//
//  Created by Jason Peebles on 2012-10-26.
//  Copyright (c) 2012 Jason Peebles. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef long long (^MemoCalculator) (int k);
typedef long long (^Formula) (MemoCalculator calc, int n);

//initialMemo: an array of NSNumber's specifying the intial members of the sequence
//f: A block representing a recursive sequence relation
MemoCalculator generateCalculator(NSArray *initialMemo, Formula f)
{
  __block NSMutableArray *mutableMemo = [initialMemo mutableCopy];
  
  //Since we're capturing 'recur' inside the block literal below, we need to specify __block storage
  //to move the pointer to the heap
  __block MemoCalculator recur;
  
  recur = [^long long (int k) {
    if (k < 0)
    {
      return 0;
    }
    
    //If we've previously computed the value for k, look it up and return
    if (k < [mutableMemo count])
    {
      return [mutableMemo[k] longLongValue];
    }
    
    //Otherwise, apply the recursive rule f to compute the new value and add it to our record
    long long result = f(recur, k);
    [mutableMemo addObject:@(result)];
    return result;
  } copy]; //We want the block to outlive this current scope, so we need to copy it
  
  return recur;
}

void outputMemoCalculatorResults(NSString *title, MemoCalculator calc, int numberOfResults)
{
  for (int i = 0; i < numberOfResults; i++)
  {
    NSLog(@"%@ Number %d is %lld \n", title, i, calc(i));
  }
}

//Some examples
int main(int argc, const char * argv[])
{
  int numberOfResults = 75;
  
  //Fibonacci Numbers
  MemoCalculator fibonacci = generateCalculator(@[@1,@1], ^long long (MemoCalculator calc, int n) {
    return  calc(n-1) + calc(n-2);
  });
  outputMemoCalculatorResults(@"Fibonacci", fibonacci, numberOfResults);
  
  //Factorial
  MemoCalculator factorial = generateCalculator(@[@1], ^long long(MemoCalculator calc, int n) {
    return n * calc(n-1);
  });
  outputMemoCalculatorResults(@"Factorial", factorial, numberOfResults);
  
  //Generates Catalan Numbers
  MemoCalculator catalan = generateCalculator(@[@1], ^long long(MemoCalculator calc, int n) {
    return (4*n - 2)*calc(n-1)/(n+1);
  });
  outputMemoCalculatorResults(@"Catalan", catalan, numberOfResults);
  
  
  return 0;
}

