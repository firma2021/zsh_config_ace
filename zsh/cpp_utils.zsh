#!/bin/bash

function cpp_run_with_valgrind() 
{
  valgrind --leak-check=full --show-error-list=yes --trace-children=yes "$@"
}

fuction cpp_compile_and_run()
{

}