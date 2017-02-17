function size_struct( st )


fds = fields(st);
for k=1:length(fds)
    cmd_var = sprintf('%s = st.%s;', fds{k}, fds{k});
    eval(cmd_var);
end

whos

end