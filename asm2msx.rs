
use std::fs::File;
use std::io::{Read, Write, BufReader};
use std::env;

fn type_of<T>(_: T) -> String{
  let a = std::any::type_name::<T>();
  return a.to_string();
}

fn str_hex(bytes: &[u8]) -> String {
     bytes.iter().fold("".to_owned(), |s, b| format!("{}{:>02x}", s, b) )
}



fn main() -> Result<(), Box<dyn std::error::Error>> {

	let _res3: u8 = 0;

	let mut head1: u32 = 1000;
	let mut str1: String = format!("{:>04} {} ", head1, "DATA");
		println!("{} ", type_of(str1.clone()));
	let mut c: u8 = 0;
	let cmax: u8 = 20;
	let dat_lf: u8 = 0x0a;
    let str0 = r#"
1 clear 100,&hd000
2 k=&hd000:def usr=k
3 read x$:if x$="END" then 8
4 if x$="" then 3
5 x2$=left$(x$,2):x$=right$(x$,len(x$)-2)
6 y=val("&h"+x2$):poke k,y:k=k+1
7 goto 4
8 a=usr(0):end
"#.trim();
 

	let args: Vec<String> = env::args().collect();
	if args.len() < 3 {
		println!("Usage: zzz6d.rs <source file name> <destination file name>\n");
    }
    let source = &args[1];
    let dest = &args[2];

    for res in BufReader::new(File::open(source)?).bytes() {
		match res {
			Err(_) => eprintln!("{}", format!("Usage: zzz6d.rs <source file name> <destination file name>")),
			Ok(_) => println!(""),
		}
		let res3 = res?;
		println!("{}", type_of(res3));
        println!("{}", str_hex(&[res3]));
		if c > cmax {
			str1 += std::str::from_utf8(&[dat_lf]).unwrap();
			c = 0;
			head1 += 10;
			str1 += &format!("{:>04} {} ", head1, "DATA");
		}else{
			c += 1;
		}
println!("{}", type_of(&str_hex(&[res3])));
		str1 += &str_hex(&[res3]);
    }

	if &str1[..1] != std::str::from_utf8(&[dat_lf]).unwrap() {
		str1 += std::str::from_utf8(&[dat_lf]).unwrap();
	}

	head1 += 10;
	str1 += &format!("{:>04} {} ", head1, "DATA END");
	str1 += std::str::from_utf8(&[dat_lf]).unwrap();

	let str2 = str0.to_owned() + std::str::from_utf8(&[dat_lf]).unwrap();
	let str3 = &str2;
	
		println!("{}", type_of(std::str::from_utf8(&[dat_lf]).unwrap()));		println!("{}", type_of(&str1));



	let file = File::create(dest);
	let file = write!(file?, "{}", str3.to_owned() + &str1);
//	let file = write!(file?, "{}", str1);
		match file {
			Err(_) => eprintln!("{}", format!("Usage: zzz6d.rs <source file name> <destination file name>")),
			Ok(_) => println!(""),

		}

	println!("{:?}",str3);
	println!("{:?}",str1);
    Ok(())
}
