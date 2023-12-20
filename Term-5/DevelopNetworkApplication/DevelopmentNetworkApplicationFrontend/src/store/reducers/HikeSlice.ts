import {IDeleteDestinationHike, IHike, IRequest} from "../../models/models.ts";
import {createSlice, PayloadAction} from "@reduxjs/toolkit";

interface HikeState {
    hike: IRequest | null;
    singleHike: IHike | null,
    isLoading: boolean;
    error: string;
    success: string;
}

const initialState: HikeState = {
    hike: null,
    singleHike: null,
    isLoading: false,
    error: '',
    success: ''
}

export const hikeSlice = createSlice({
    name: 'hike',
    initialState,
    reducers: {
        hikesFetching(state) {
            state.isLoading = true
        },
        hikesFetched(state, action: PayloadAction<IRequest>) {
            state.isLoading = false
            state.error = ''
            state.hike = action.payload
        },
        hikeFetched(state, action: PayloadAction<IHike>) {
            state.isLoading = false
            state.error = ''
            state.singleHike = action.payload
        },
        hikesDeleteSuccess(state, action: PayloadAction<IDeleteDestinationHike>) {
            state.isLoading = false
            const text = action.payload.description ?? ""
            state.error = text
            state.success = "Город успешно удалён из заявки"
        },
        hikesUpdated(state, action: PayloadAction<string[]>) {
            state.isLoading = false
            state.error = action.payload[0]
            state.success = action.payload[1]
        },
        hikesDeleteError(state, action: PayloadAction<string>) {
            state.isLoading = false
            state.error = action.payload
        },
        hikesFetchedError(state, action: PayloadAction<string>) {
            state.isLoading = false
            state.error = action.payload
        },
    },
})

export default hikeSlice.reducer;