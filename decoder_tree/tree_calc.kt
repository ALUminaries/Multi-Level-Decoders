import kotlin.math.*

// gate transistor costs
val t_not = 2
val t_and2 = 6
fun t_and_k_plus_1(k: Int): Int = (2 * (k + 1)) + 2 // t_and2 * k

// tree decoder architectural parameters
var f_max = 8  // maximum fanout (top level decoder output size)
var b = 4     // base decoder *output* size

fun calc_f(k: Int): Int {
    return max(2, min(f_max, 2.0.pow(ceil(log2(sqrt(2.0.pow(k.toDouble())))).toDouble()).roundToInt()))
}

fun D_en(k: Int): Int {
    return ((t_not * k * (2.0.pow((k - 1).toDouble()).roundToInt())) + (t_and_k_plus_1(k) * 2.0.pow(k.toDouble()).roundToInt()))
}

fun D_tau(k: Int): Int {
    var f = calc_f(k).toDouble()

    // base case
	if (2.0.pow(k.toDouble()) <= b || (2.0.pow(k.toDouble()) / f) < 2) {
		return D_en(k)
    }
    // recursive case
    else {
     	return (D_tau(log2(f).roundToInt()) + (f * D_tau(k - log2(f).roundToInt())).roundToInt())
    }
}


fun main(args: Array<String>) {
   val k_list = 2..18
   val f_max_list = listOf(2, 4, 8, 16, 32, 64, 128)
   val b_list = listOf(4, 8, 16, 32, 64, 128)
    
//    var k = 9

   // csv
   val csv = true
    
    // csv header
    if (csv) {
        print("f_max, b, ")
        for (k in k_list) {
            print("$k")
			if (k != 18)
                print(", ") 
            else 
                println() 
        }
    }
   
    
   for (i in f_max_list) {
       f_max = i
       for (j in b_list) {
           b = j
           if (csv) print("${f_max}, ${b}, ")
           for (k in k_list) {
               // human-readable mode
               if (!csv) {
                   println("Cost(k = $k, f_max = $f_max, b = $b) = ${D_tau(k)}")
               } 
               // csv mode
               else {
                   print("${D_tau(k)}")
                   if (k != 18)
                   	   print(", ") 
                   else 
					   println()   
               }
           }
       }
   } 
}