syms V v_o T_o V_o p_1 p_2 p_3 p_4 q_1 q_2 q_3

y( V, v_o, T_o, V_o, p_1, p_2, p_3, p_4, q_1, q_2, q_3) = T_o ((V - v_o)*( p1 + (V - v_o)*( p2 + (V - v_o)*(p3 + p4*(V - v_o)))))/(1 + (V - v_o)*(q1 + (V - v_o)*(q2 + q3*(V - v_o))));
latex(y)