import {createSlice, PayloadAction} from "@reduxjs/toolkit";

interface UserState {
    isLoading: boolean
    error: string
    success: string
    isAuth: boolean
    role: string
}

const initialState: UserState = {
    isLoading: false,
    isAuth: false,
    error: '',
    success: '',
    role: ''
}

export const userSlice = createSlice({
    name: 'user',
    initialState,
    reducers: {
        startProcess(state) {
            state.isLoading = true
        },
        setAuthStatus(state, action: PayloadAction<boolean>) {
            state.isAuth = action.payload
        },
        setRole(state, action: PayloadAction<string>) {
            state.role = action.payload
        },
        setStatuses(state, action: PayloadAction<string[]>) {
            state.isLoading = false
            state.error = action.payload[0]
            state.success = action.payload[1]
        },
        setError(state, action: PayloadAction<string>) {
            state.isLoading = false
            state.error = action.payload
            state.success = ''
        },
        resetStatuses(state) {
            state.isLoading = false
            state.error = ''
            state.success = ''
        },
    },
})

export default userSlice.reducer;