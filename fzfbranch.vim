" Change branches
fun! s:change_branch(e)
    let res = system("git checkout " . a:e)
    :e!
    :AirlineRefresh
    echom "Change branch to" . a:e
endfun

command! Gbranch call fzf#run(
            \{
            \'source': 'git branch',
            \'sink': function('<sid>change_branch'),
            \'options': '-m',
            \'down': '20%'
            \})
