//
//  ViewController.swift
//  calc
//
//  Created by Emma Välme on 2020-03-24.
//  Copyright © 2020 Emma Välme. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var mathEvent = false
    var lastPressed = 0;
    var willBeCountArray = [String]();
 
    
    @IBOutlet weak var display: UILabel! // the big label
    
    @IBOutlet weak var showsAllDisplay: UILabel! // the upper label where the whole ekvation is shown
    
    @IBAction func numbers(_ sender: UIButton) //function for when nr 0-9 and comma (,) are pressed
    {
        if lastPressed != 16 // if "=" is not the the last one pressed
        {
            lastPressed = sender.tag
            if mathEvent == true // if ongoing math
            {
                display.text =  String(sender.tag - 1)
                showsAllDisplay.text = showsAllDisplay.text! + String(sender.tag - 1)
                mathEvent = false
            }
            else
            {
                if sender.tag == 18 // special for comma
                {
                    display.text = display.text! + "."
                    showsAllDisplay.text = showsAllDisplay.text! + "."
                }
                else{
                display.text = display.text! + String(sender.tag - 1)
                showsAllDisplay.text = showsAllDisplay.text! + String(sender.tag - 1)
                }
            }
            lastPressed = sender.tag;
        }
        else // if last pressed was =, rinse all
        {
            display.text = String(sender.tag - 1);
            mathEvent = false
            lastPressed = 0;
            showsAllDisplay.text = String(sender.tag - 1)
        }
        
    }
      
    
    @IBAction func buttons(_ sender: UIButton) // when buttons are pressed, write on display and add to array
    {
        willBeCountArray.append(display.text!)
        lastPressed = sender.tag
            if display.text != "" &&
            sender.tag != 11 &&
            sender.tag != 16
        {
            
            if sender.tag == 12 //divide
            {
                display.text = "/";
                willBeCountArray.append(display.text!)
                showsAllDisplay.text = showsAllDisplay.text! + display.text!
                
            }
            else if sender.tag == 13 //multiply
            {
                display.text = "x";
                showsAllDisplay.text = showsAllDisplay.text! + display.text!
                willBeCountArray.append(display.text!)
            }
            else if sender.tag == 14 //minus
            {
                display.text = "-";
                showsAllDisplay.text = showsAllDisplay.text! + display.text!
                willBeCountArray.append(display.text!)
            }
            else if sender.tag == 15 // plus
            {
                display.text = "+";
                showsAllDisplay.text = showsAllDisplay.text! + display.text!
                willBeCountArray.append(display.text!)
            }
            else if sender.tag == 17 // plus
            {
                display.text = "%";
                showsAllDisplay.text = showsAllDisplay.text! + display.text!
                willBeCountArray.append(display.text!)
            }
            mathEvent = true;
        }
        
        else if sender.tag == 16 // when = is pressed, do all counting
        {
            showsAllDisplay.text = showsAllDisplay.text! + "="
            while willBeCountArray.contains("x") || willBeCountArray.contains("/") || willBeCountArray.contains("%")
                // while the array contains of following, these will be handled first, from left to right
            {
                let first_sign = FirstSign(willBeCountArray)
               
                if willBeCountArray[first_sign!] == "x"
                {
                   willBeCountArray = Count(&willBeCountArray, first_sign: first_sign, operation: "x")
                }
                
                else if willBeCountArray[first_sign!] == "/"
                {
                   willBeCountArray = Count(&willBeCountArray, first_sign: first_sign, operation: "/")
                }
                    
                else if willBeCountArray[first_sign!] == "%"
               {
                  willBeCountArray = Count(&willBeCountArray, first_sign: first_sign, operation: "%")
               }

            }
            while willBeCountArray.contains("+") || willBeCountArray.contains("-")
            {
                let first_sign = FirstSign2(willBeCountArray)
                    
                     if willBeCountArray[first_sign!] == "+"
                     {
                        willBeCountArray = Count(&willBeCountArray, first_sign: first_sign, operation: "+")
                     }
                     
                     else if willBeCountArray[first_sign!] == "-"
                     {
                        willBeCountArray = Count(&willBeCountArray, first_sign: first_sign, operation: "-")
                     }

                }
            display.text = willBeCountArray[0]
            willBeCountArray.removeAll();
            }
            
        else if sender.tag == 11
        {
            display.text = ""
            mathEvent = false
            showsAllDisplay.text = ""
            willBeCountArray.removeAll();

        }
    }

    // FUnction to find first sign of x / and % in array
    func FirstSign(_ theArray: Array<String>) -> Int? {
        var first_sign: Int? = nil
        let first_x = theArray.firstIndex(of: "x")
        let first_div = theArray.firstIndex(of: "/")
        let first_mod = theArray.firstIndex(of: "%")
        
        if first_x != nil && first_div == nil ||  first_x != nil && first_x! < first_div!
        {
            first_sign = first_x
        }
        else
        {
            first_sign = first_div
        }
        if first_sign != nil && first_mod == nil ||  first_sign != nil && first_sign! < first_mod!
        {
            return first_sign
        }
        else
        {
           first_sign = first_mod
            return first_sign
        }
    }
    
    // func to find if + or - is first
    func FirstSign2(_ theArray: Array<String>) -> Int? {
        var first_sign: Int? = nil
        let first_plus = theArray.firstIndex(of: "+")
        let first_minus = theArray.firstIndex(of: "-")
        
        if first_plus != nil && first_minus == nil ||  first_plus != nil && first_plus! < first_minus!
        {
            first_sign = first_plus
            return first_sign
        }
        else
        {
            first_sign = first_minus
            return first_sign
        }
    }
    
    
    // counting function- rearrage in array
    func Count(_ theArray : inout [String], first_sign : Int?, operation : String) -> [String] {
        let num1 = Double(theArray[first_sign! - 1]) ?? 0
        let num2 = Double(theArray[first_sign! + 1]) ?? 0
        var holder = num1 // just to get a value
        if operation == "x"
        {
        holder = num1 * num2
        }
        if operation == "/"
         {
         holder = num1 / num2
         }
        if operation == "%"
         {
         holder = (num1/100) * num2 // X % off Y
         }
        if operation == "+"
           {
           holder = num1 + num2
           }
        if operation == "-"
           {
           holder = num1 - num2
           }
            
        let holder2 = String(holder) //
        theArray.insert(holder2, at: first_sign!+2) // insert the answer in array
        theArray.remove(at: first_sign!) // remove the used elements (num1, num2 and operation)
        theArray.remove(at: first_sign!)
        theArray.remove(at: first_sign! - 1)
        return theArray
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


}


