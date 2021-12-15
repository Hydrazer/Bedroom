use v6.d;


unit sub MAIN(
  Str $file where -> $file {$file.IO.f || die "file does not exist"}, #= provide a file to where your code is
);


enum Direction (
  Up => [-1, 0],
  Down => [1, 0],
  Left => [0, -1],
  Right => [0, 1],
);

my Str:D @direction-arr = <Up Left Down Right>;

my Str:D $code-str = $file.IO.slurp;

if $code-str !~~ /"🛏"/ {
  die qq{need at least one halt "🛏 " in your program}
}

my Array:D @code-arr = $code-str.lines.map(-> $line {$line.comb.Array});

my Int:D $code-max-len = @code-arr.map(-> @line {@line.elems}).max;
@code-arr .= map(-> @line {[|@line, |[" " xx ($code-max-len - @line.elems)]]});

my Direction:D $current-dir = Direction::Right;
my (Int:D $move-i, Int:D $move-j) = $current-dir;
my Int:D $instruc-i = 0;
my Int:D $instruc-j = 0;
my Int:D $memory-ind = 0;
my %memory-hash{Int:D} of Int:D;


my Str:D $instruc = @code-arr[$instruc-i][$instruc-j];

while $instruc ne "🛏" {
  given $instruc {
    when "⬆️" {
      $current-dir = Direction::Up
    }

    when "⬇️" {
      $current-dir = Direction::Down
    }

    when "⬅️" {
      $current-dir = Direction::Left
    }

    when "➡️" {
      $current-dir = Direction::Right
    }

    when "📗" {
      ++%memory-hash{$memory-ind}
    }

    when "🧸" {
      --%memory-hash{$memory-ind}
    }
    when "🪄" {
      $memory-ind .= succ
    }

    when "🪆" {
      $memory-ind .= pred
    }

    when "🗄" {
      %memory-hash{$memory-ind} = getc.ord
    }

    when "🗒" {
      print %memory-hash{$memory-ind}
    }

    when "📐" {
      if %memory-hash{$memory-ind} == 0 {

        $current-dir = Direction::{@direction-arr[@direction-arr.first(-> $dir {Direction::{$dir} eqv $current-dir}, :k).succ % 4]};
      }
    }
  }
  
  ($move-i, $move-j) = $current-dir;
  $instruc-i += $move-i;
  $instruc-j += $move-j;
  $instruc = @code-arr[$instruc-i][$instruc-j];
}